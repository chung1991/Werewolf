//
//  StepOneController.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import UIKit

protocol StepOneViewModel {
    var numberOfPlayers: Int { get set }
}

struct StepOneViewModelImpl: StepOneViewModel {
    var numberOfPlayers: Int = 0
}

protocol StepOneControllerDelegate: AnyObject {
    func moveToStep2(_ numberOfPlayer: Int)
}

class StepOneController: UIViewController {

    lazy var viewModel: StepOneViewModel = StepOneViewModelImpl()
    lazy var questionLabel = UILabel()
    lazy var textfield = UITextField()
    lazy var nextButton = UIButton()
    weak var delegate: StepOneControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAutolayouts()
        setupDelegates()
        reloadData()
    }

    func setupViews() {
        view.backgroundColor = .systemBackground
        
        questionLabel.font = .systemFont(ofSize: 30)
        view.addSubview(questionLabel)
        
        textfield.borderStyle = .roundedRect
        view.addSubview(textfield)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.label, for: .normal)
        view.addSubview(nextButton)
    }
    
    func setupAutolayouts() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -5),
            
            textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textfield.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 5),
            textfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 5)
            
        ])
    }
    
    func setupDelegates() {
        nextButton.addTarget(self,
                             action: #selector(didTapNextButton),
                             for: .touchUpInside)
    }
    
    func reloadData() {
        questionLabel.text = "How many players?"
    }
    
    @objc func didTapNextButton() {
        guard let numberOfPlayer = textfield.text, !numberOfPlayer.isEmpty else {
            print("Number of player textfield is empty")
            return
        }
        guard let value = Int(numberOfPlayer) else {
            print("Number of player textfield is not number")
            return
        }
        viewModel.numberOfPlayers = value
        delegate?.moveToStep2(value)
    }
}

