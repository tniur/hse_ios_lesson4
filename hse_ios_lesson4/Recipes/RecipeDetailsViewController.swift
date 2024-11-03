//
//  RecipeDetailsViewController.swift
//  hse_ios_lesson4
//
//  Created by Pavel Bobkov on 03.11.2024.
//

import UIKit
import SnapKit

final class RecipeDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var details: RecipeDetailsModel?
    private let id: String
    private let recipesClient: RecipesClientProtocol = RecipesClient.shared
    
    // MARK: - Views
    
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
    
    private let difficulty: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let portion: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life-Cycle
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.title = "Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupView()
        setupContent()
    }
    
    private func setupContent() {
        recipeTitle.text = details?.title
        difficulty.text = details?.difficulty
        portion.text = details?.portion
        time.text = details?.time
        
        let image = details?.image
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
    }
    
    private func setupView() {
        [recipeImage, recipeTitle, difficulty, portion, time].forEach {
            view.addSubview($0)
        }
        
        recipeImage.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(200)
        }
        
        recipeTitle.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        difficulty.snp.makeConstraints { make in
            make.top.equalTo(recipeTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        portion.snp.makeConstraints { make in
            make.top.equalTo(difficulty.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        time.snp.makeConstraints { make in
            make.top.equalTo(portion.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - Methods
    
    private func fetchData() {
        recipesClient.fetchRecipeDetailsById(id: id) { [weak self] result in
            switch result {
            case .success(let details):
                self?.details = details
                self?.setupContent()
            case .failure(let error):
                print("Failed to fetch or decode recipes:", error)
            }
        }
    }
}
