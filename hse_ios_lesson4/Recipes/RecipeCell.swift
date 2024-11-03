//
//  RecipeCell.swift
//  hse_ios_lesson4
//
//  Created by Pavel Bobkov on 03.11.2024.
//

import UIKit
import SnapKit

final class RecipeCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = "RecipeCell"
    
    static let cellHeight: CGFloat = 150
    
    private let recipesClient: RecipesClientProtocol = RecipesClient.shared
    
    // MARK: - View
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.customGray
        return view
    }()
    
    private let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()
    
    private let recipeDifficulty: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life-Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    func configure(title: String, difficulty: String, image: String?) {
        if let image {
            recipesClient.fetchImage(from: image) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        self?.recipeImage.image = image
                    }
                case .failure(let error):
                    print("Failed to load image:", error)
                }
            }
        }
        
        recipeTitle.text = title
        recipeDifficulty.text = difficulty
    }
    
    private func setup() {
        contentView.addSubview(containerView)
        [recipeImage, recipeTitle, recipeDifficulty].forEach { containerView.addSubview($0) }
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        recipeImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.width.equalTo(120)
        }
        
        recipeTitle.snp.makeConstraints { make in
            make.leading.equalTo(recipeImage.snp_trailingMargin).offset(20)
            make.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        recipeDifficulty.snp.makeConstraints { make in
            make.leading.equalTo(recipeImage.snp_trailingMargin).offset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
