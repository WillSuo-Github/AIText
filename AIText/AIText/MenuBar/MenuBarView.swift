//
//  MenuBarView.swift
//  AIText
//
//  Created by will Suo on 2025/4/11.
//


import Cocoa

enum ImageStatus {
    case normal
    case loading
    case error
}

class MenuBarView: NSView {
    
    // MARK: - Properties
    private var imageStatus: ImageStatus = .normal {
        didSet {
            DispatchQueue.main.async {
                self.updateUI(for: self.imageStatus)
            }
        }
    }
    
    private lazy var imageView: NSImageView = {
        let iv = NSImageView()
        iv.imageAlignment = .alignCenter
        iv.imageScaling = .scaleProportionallyUpOrDown
        return iv
    }()
    
    private lazy var progressIndicator: NSProgressIndicator = {
        let indicator = NSProgressIndicator()
        indicator.isIndeterminate = true
        indicator.style = .spinning
        indicator.controlSize = .small
        indicator.isHidden = true
        return indicator
    }()
    
    
    // MARK: - Init
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(imageView)
        addSubview(progressIndicator)
        
        setupLayout()
        setupNotifications()
        
        updateUI(for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            progressIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    /// Register notification observers
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleQuickActionSuccess),
            name: .QuickActionSuccess,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleQuickActionStart),
            name: .QuickActionStart,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleQuickActionError),
            name: .QuickActionError,
            object: nil
        )
    }
    
    
    // MARK: - Update UI
    
    /// Update icon or show progress based on status
    private func updateUI(for status: ImageStatus) {
        switch status {
        case .normal:
            let img = NSImage(named: "logo")
            img?.isTemplate = true
            imageView.image = img

            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(nil)
            
        case .loading:
            imageView.image = nil
            
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(nil)
            
        case .error:
            let img = NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: nil)
            img?.isTemplate = true 
            imageView.image = img
            
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.imageStatus = .normal
            }
        }
    }
    
    // MARK: - Notification Handlers
    
    @objc private func handleQuickActionSuccess() {
        imageStatus = .normal
    }
    
    @objc private func handleQuickActionStart() {
        imageStatus = .loading
    }
    
    @objc private func handleQuickActionError() {
        imageStatus = .error
    }
}
