extension UIColor {
    // class func fromString(hex: String) -> UIColor? {
    //     var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    //     if (cString.hasPrefix("#")) {
    //         cString.remove(at: cString.startIndex)
    //     }
    
    //     if ((cString.count) != 6) {
    //         return nil
    //     }
    
    //     var rgbValue:UInt64 = 0
    //     Scanner(string: cString).scanHexInt64(&rgbValue)
    
    //     return UIColor(
    //         red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    //         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    //         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    //         alpha: CGFloat(1.0)
    //     )
    // }
    
    public convenience init?(hexString: String) {
        let mask = 0x000000FF
        
        if hexString.hasPrefix("#") {
            let hexColor = hexString.suffix(hexString.count - 1)
            if hexColor.count == 8 {
                let scanner = Scanner(string: String(hexColor))
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    let r = CGFloat(Int(hexNumber >> 16) & mask) / 255.0
                    let g = CGFloat(Int(hexNumber >> 8) & mask) / 255.0
                    let b = CGFloat(Int(hexNumber) & mask) / 255.0
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}
