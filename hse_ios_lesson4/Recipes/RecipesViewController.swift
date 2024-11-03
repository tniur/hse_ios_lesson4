//
//  RecipesViewController.swift
//  hse_ios_lesson4
//
//  Created by Pavel Bobkov on 03.11.2024.
//

import UIKit
import SnapKit

final class RecipesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var data: [RecipeModel] = []
    
    private let recipesClient: RecipesClientProtocol = RecipesClient.shared
    
    // MARK: - View
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        navigationItem.title = "Recipes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchData() {
        recipesClient.fetchRecipes { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.data = recipes
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch or decode recipes:", error)
            }
        }
    }
}

// MARK: - UITableViewDataSources

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configure(title: data[indexPath.row].title ?? "-", difficulty: data[indexPath.row].difficulty ?? "-", image: data[indexPath.row].image)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        RecipeCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsViewController = RecipeDetailsViewController(id: data[indexPath.row].id)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
