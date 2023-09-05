import UIKit.UIImageView

private var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(urlString: String?, low: NSLayoutConstraint, high: NSLayoutConstraint) async {
        let spinner = UIActivityIndicatorView(style: .medium)
        if let imageUrl = urlString {
            if let image = imageCache.object(forKey: imageUrl as NSString) as? UIImage {
                self.image = image
                return
            }
            
            guard let url = URL(string: imageUrl) else {
                self.image = nil
                return
            }
            
            self.image = UIImage()
            self.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
            
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            
            self.addSubview(spinner)
            
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    spinner.removeFromSuperview()
                    
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: imageUrl as NSString)
                        self.image = image
                    }
                } catch {
                    low.priority = .defaultHigh
                    high.priority = .defaultLow
                    spinner.removeFromSuperview()
                    return
                }
            }
            return
        }
        
        self.image = nil
    }
}
