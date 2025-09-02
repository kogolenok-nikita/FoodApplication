import UIKit

final class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var customSize = super.sizeThatFits(size)
        customSize.height = 83
        return customSize
    }
}
