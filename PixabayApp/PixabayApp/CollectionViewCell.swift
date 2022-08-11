//
//  CollectionViewCell.swift
//  PixabayApp
//
//  Created by Rizayev Nematzhon on 02.04.2022.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private properties
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let titleLabel = UILabel()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func configureView() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        backgroundColor = UIColor(red: 237/255, green: 248/255, blue: 235/255, alpha: 1)
    }
    
    private func setupInitialLayout() {
        let stackView = UIStackView(
            arrangedSubviews:
                [
                    imageView,
                    titleLabel
                ]
        )
        stackView.alignment = .center
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        imageView.snp.makeConstraints {
            $0.height.equalTo(154)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public functions
    
    func setupCell(imageURL: String?, title: String?) {
        titleLabel.text = title ?? "some name"
        guard let image = URL(string: imageURL ?? "") else { return }
        
        URLSession.shared.dataTask(with: image) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.imageView.image = image
                self?.titleLabel.text = title
            }
        }.resume()
    }
}
