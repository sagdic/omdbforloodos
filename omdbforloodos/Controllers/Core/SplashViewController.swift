//
//  SplashViewController.swift
//  omdbforloodos
//
//  Created by tayfun on 9.10.2022.
//

import UIKit
import FirebaseRemoteConfig
import Gifu

class SplashViewController: UIViewController {
    
    
    private var remoteConfig = RemoteConfig.remoteConfig()
    let reachability = try! Reachability()
    let loadView = LoadingView()
    

    private let loadingView: GIFImageView = {
        let imageView = GIFImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.animate(withGIFNamed: "loodos")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        imageView.stopAnimatingGIF()
        return imageView
    }()
    
    private let centerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(named: "loodosColor")
        label.font = label.font.withSize(40)
        return label
    }()
    
    private func applyConstraints() {
        let centerLabelConstraints = [
        centerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        let loadingViewConstraints = [
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(centerLabelConstraints)
        NSLayoutConstraint.activate(loadingViewConstraints)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(centerLabel)
        view.addSubview(loadingView)
        loadView.showLoadingView(on: self)
        applyConstraints()
        
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerLabel.frame = view.bounds
        loadingView.frame = view.bounds
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                self.view.window?.rootViewController?.dismiss(animated: true)
            }
            self.reachability.whenUnreachable = { _ in
                print("Not reachable")
                self.navigationController?.pushViewController(NetworkErrorViewController(), animated: true)
            }
            
            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }

    deinit {
        reachability.stopNotifier()
    }

    //MARK: - REMOTE CONFIG DEFAULTS
        func setupRemoteConfigDefaults() {
        let defaultValue = ["loodos_text": "" as NSObject]
        remoteConfig.setDefaults(defaultValue)
        }
        
    //    MARK: - FETCH REMOTE CONFIG
        func fetchRemoteConfig(){
        remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
        guard error == nil else { return }
        
        remoteConfig.activate()
        self.displayNewValues()
        }}
        
    //    MARK: - DISPLAY REMOTE CONFIG VALUE
        func displayNewValues(){
        let newLabelText = remoteConfig.configValue(forKey: "loodos_text").stringValue ?? ""
            self.loadingView.stopAnimatingGIF()
            self.loadingView.isHidden = true
            loadView.dismissLoadingView()
            centerLabel.text = newLabelText
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.navigationController?.pushViewController(HomeViewController(), animated: true)
            }
        }
}
