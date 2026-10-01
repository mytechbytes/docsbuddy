// Composes raw simulator captures into Play Store marketing screenshots.
//   compose <phone|tablet> <specs.json> <outDir>
// Each output is an opaque 9:16 JPEG: brand gradient, caption, rounded device
// card with the OS status bar / home indicator painted out.
import AppKit
import CoreText

struct Item: Codable {
    let src: String
    let out: String
    let title: String
    let sub: String
    var topFill: Int?
    var bottomFill: Int?
}

let args = CommandLine.arguments
guard args.count == 4 else { print("usage: compose <phone|tablet> <specs.json> <outDir>"); exit(1) }
let mode = args[1]
let items = try! JSONDecoder().decode([Item].self, from: Data(contentsOf: URL(fileURLWithPath: args[2])))
let outDir = args[3]
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

let tablet = mode == "tablet"
let W = tablet ? 1440 : 1080
let H = tablet ? 2560 : 1920

// Brand font (variable): register, then pick the heavy weight.
let fontURL = URL(fileURLWithPath: "/Users/viveksingh/development/projects/docsbuddy/docsbuddy-mobile/assets/fonts/PlusJakartaSans-Variable.ttf")
CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)

func brandFont(_ size: CGFloat, weight: Double) -> NSFont {
    let base = CTFontCreateWithName("Plus Jakarta Sans" as CFString, size, nil)
    let variations: [NSNumber: NSNumber] = [NSNumber(value: 0x77676874): NSNumber(value: weight)] // 'wght'
    let desc = CTFontCopyFontDescriptor(base)
    let varDesc = CTFontDescriptorCreateCopyWithAttributes(desc, [kCTFontVariationAttribute: variations] as CFDictionary)
    let f = CTFontCreateWithFontDescriptor(varDesc, size, nil)
    if CTFontCopyFamilyName(f) as String == "Plus Jakarta Sans" || (CTFontCopyFamilyName(f) as String).contains("Jakarta") {
        return f as NSFont
    }
    return NSFont.systemFont(ofSize: size, weight: weight >= 700 ? .heavy : .medium)
}

func color(_ hex: UInt32, _ a: CGFloat = 1) -> NSColor {
    NSColor(srgbRed: CGFloat((hex >> 16) & 0xFF) / 255, green: CGFloat((hex >> 8) & 0xFF) / 255, blue: CGFloat(hex & 0xFF) / 255, alpha: a)
}

func sample(_ rep: NSBitmapImageRep, _ x: Int, _ y: Int) -> NSColor {
    rep.colorAt(x: min(max(x, 0), rep.pixelsWide - 1), y: min(max(y, 0), rep.pixelsHigh - 1))!.usingColorSpace(.sRGB)!
}

func rgbContext(_ w: Int, _ h: Int) -> CGContext {
    CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0,
              space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
}

/// The capture with the OS status bar and home indicator cropped away.
func cleaned(_ path: String, topCrop: Int, bottomCrop: Int) -> CGImage {
    let rep = NSBitmapImageRep(data: try! Data(contentsOf: URL(fileURLWithPath: path)))!
    let w = rep.pixelsWide, h = rep.pixelsHigh
    return rep.cgImage!.cropping(to: CGRect(x: 0, y: topCrop, width: w, height: h - topCrop - bottomCrop))!
}

func drawText(_ s: String, font: NSFont, color c: NSColor, in rect: CGRect, align: NSTextAlignment = .center, lineSpacing: CGFloat = 0) {
    let p = NSMutableParagraphStyle()
    p.alignment = align
    p.lineSpacing = lineSpacing
    p.lineBreakMode = .byWordWrapping
    NSAttributedString(string: s, attributes: [.font: font, .foregroundColor: c, .paragraphStyle: p]).draw(with: rect, options: [.usesLineFragmentOrigin])
}

for item in items {
    let topCrop = item.topFill ?? (tablet ? 56 : 128)
    let bottomCrop = item.bottomFill ?? (tablet ? 44 : 96)
    let shot = cleaned(item.src, topCrop: topCrop, bottomCrop: bottomCrop)

    let ctx = rgbContext(W, H)
    let ns = NSGraphicsContext(cgContext: ctx, flipped: false)
    NSGraphicsContext.current = ns

    // Background gradient (brand navy → teal).
    NSGradient(colors: [color(0x16304F), color(0x1F3A5F), color(0x2A7F9E)], atLocations: [0, 0.45, 1], colorSpace: .sRGB)!
        .draw(in: NSRect(x: 0, y: 0, width: W, height: H), angle: -62)
    // Soft light blob for depth.
    NSGradient(colors: [color(0xFFFFFF, 0.14), color(0xFFFFFF, 0)])!
        .draw(fromCenter: CGPoint(x: Double(W) * 0.82, y: Double(H) * 0.88), radius: 0,
              toCenter: CGPoint(x: Double(W) * 0.82, y: Double(H) * 0.88), radius: Double(W) * 0.7, options: [])

    // Caption (positions measured from the top edge).
    let titleSize: CGFloat = tablet ? 84 : 68
    let subSize: CGFloat = tablet ? 42 : 34
    let capTop: CGFloat = tablet ? 140 : 100
    let margin: CGFloat = tablet ? 120 : 90
    let titleLines = CGFloat(item.title.components(separatedBy: "\n").count)
    let titleH = titleSize * 1.3 * titleLines
    let titleRect = CGRect(x: margin, y: CGFloat(H) - capTop - titleH, width: CGFloat(W) - margin * 2, height: titleH)
    drawText(item.title, font: brandFont(titleSize, weight: 800), color: .white, in: titleRect)
    let subH = subSize * 1.5 * 2
    let subRect = CGRect(x: margin, y: titleRect.minY - 24 - subH, width: CGFloat(W) - margin * 2, height: subH)
    drawText(item.sub, font: brandFont(subSize, weight: 500), color: color(0xFFFFFF, 0.82), in: subRect)

    // Device card.
    let aspect = CGFloat(shot.width) / CGFloat(shot.height)
    let cardH: CGFloat = tablet ? 1740 : 1450
    let cardW = cardH * aspect
    let cardTopFromTop: CGFloat = tablet ? 560 : 410
    let card = CGRect(x: (CGFloat(W) - cardW) / 2, y: CGFloat(H) - cardTopFromTop - cardH, width: cardW, height: cardH)
    let radius: CGFloat = tablet ? 70 : 78

    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -26), blur: 60, color: NSColor.black.withAlphaComponent(0.38).cgColor)
    ctx.setFillColor(NSColor.white.cgColor)
    ctx.addPath(CGPath(roundedRect: card, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.fillPath()
    ctx.restoreGState()

    ctx.saveGState()
    ctx.addPath(CGPath(roundedRect: card, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.clip()
    ctx.interpolationQuality = .high
    ctx.draw(shot, in: card)
    ctx.restoreGState()

    ctx.setStrokeColor(NSColor.white.withAlphaComponent(0.55).cgColor)
    ctx.setLineWidth(3)
    ctx.addPath(CGPath(roundedRect: card.insetBy(dx: 1.5, dy: 1.5), cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.strokePath()

    let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
    let data = rep.representation(using: .jpeg, properties: [.compressionFactor: 0.94])!
    try! data.write(to: URL(fileURLWithPath: outDir + "/" + item.out))
    print("wrote", item.out, "\(W)x\(H)", "card \(Int(cardW))x\(Int(cardH))")
}
