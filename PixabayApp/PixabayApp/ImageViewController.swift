//
//  ImageViewController.swift
//  PixabayApp
//
//  Created by Rizayev Nematzhon on 02.04.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(), for: .normal)
        button.addTarget(self, action: #selector(cancelView), for: .touchUpInside)
        return button
    }()
    
    private var image: String = .init()
    
    init(image: String) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        setupImage(imageURL: image)
        setupInitialLayout()
    }
    
    @objc private func cancelView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupImage(imageURL: String?) {
        guard let image = URL(string: imageURL ?? "") else { return }
        URLSession.shared.dataTask(with: image) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.imageView.image = image
            }
        }.resume()
    }
}

extension ImageViewController {
    
    private func setupInitialLayout() {
      [imageView, closeButton].forEach {
          view.addSubview($0)
      }

      imageView.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.center.equalToSuperview()
      }

      closeButton.snp.makeConstraints {
        $0.bottom.leading.trailing.equalToSuperview().inset(50)
      }
    }
}
