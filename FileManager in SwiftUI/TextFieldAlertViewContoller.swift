//
//  TextFieldAlertViewController.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import SwiftUI
import Combine

class TextFieldAlertViewController: UIViewController {

    // MARK: - Life Cycle
    init(title: String, message: String?, noteTitle: Binding<String?>, noteDescription: Binding<String?>, isPresented: Binding<Bool>?) {
        self.alertTitle = title
        self.message = message
        self._noteTitle = noteTitle
        self._noteDescription = noteDescription
        self.isPresented = isPresented
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let alertTitle: String
    private let message: String?
    @Binding private var noteTitle: String?
    @Binding private var noteDescription: String?
    private var isPresented: Binding<Bool>?

    private var subscription: AnyCancellable?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentAlertController()
    }

    // MARK: - Methods
    private func presentAlertController() {
        guard subscription == nil else { return }
        let vc = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        vc.addTextField { [weak self] textField in
            guard let self = self else { return }
            self.subscription = NotificationCenter.default
                                    .publisher(for: UITextField.textDidChangeNotification, object: textField)
                                    .map { ($0.object as? UITextField)?.text }
                                    .assign(to: \.noteTitle, on: self)
        }
        
        vc.addTextField { [weak self] textField in
            guard let self = self else { return }
            self.subscription = NotificationCenter.default
                                    .publisher(for: UITextField.textDidChangeNotification, object: textField)
                                    .map { ($0.object as? UITextField)?.text }
                                    .assign(to: \.noteDescription, on: self)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.isPresented?.wrappedValue = false
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { (<#UIAlertAction#>) in
            <#code#>
        }
        
        vc.addAction(cancelAction)
        vc.addAction(createAction)
        present(vc, animated: true, completion: nil)
    }
}
