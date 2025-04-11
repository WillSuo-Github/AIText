//
//  MenuBarView.swift
//  AIText
//
//  Created by will Suo on 2025/4/11.
//


import Cocoa

// 1. 定义状态
enum ImageStatus {
    case normal
    case loading
    case error
}

// 2. 自定义 NSView
class MenuBarView: NSView {
    
    // MARK: - Properties
    
    /// 用来追踪当前图标状态
    private var imageStatus: ImageStatus = .normal {
        didSet {
            DispatchQueue.main.async {
                self.updateUI(for: self.imageStatus)
            }
        }
    }
    
    /// 显示图标的视图（正常 / 错误）
    private lazy var imageView: NSImageView = {
        let iv = NSImageView()
        iv.imageAlignment = .alignCenter
        iv.imageScaling = .scaleProportionallyUpOrDown
        return iv
    }()
    
    /// 加载指示器（菊花）
    private lazy var progressIndicator: NSProgressIndicator = {
        let indicator = NSProgressIndicator()
        indicator.isIndeterminate = true
        indicator.style = .spinning
        indicator.controlSize = .small
        indicator.isHidden = true // 默认隐藏
        return indicator
    }()
    
    
    // MARK: - Init
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // 添加子视图
        addSubview(imageView)
        addSubview(progressIndicator)
        
        setupLayout()
        setupNotifications()
        
        // 初始化时先呈现 normal 状态
        updateUI(for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    /// 设置 Auto Layout 布局
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 让 imageView 填满父视图
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 让 progressIndicator 居中
            progressIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    /// 注册通知监听
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
    
    /// 根据不同状态更换图标或显示进度
    private func updateUI(for status: ImageStatus) {
        switch status {
        case .normal:
            // 显示正常图标
            let img = NSImage(named: "logo")
            img?.isTemplate = true  // 让系统可自动变暗 / 变亮
            imageView.image = img
            
            // 隐藏进度指示器
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(nil)
            
        case .loading:
            // 清空图标，只显示旋转菊花
            imageView.image = nil
            
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(nil)
            
        case .error:
            // 显示一个错误图标 (SF Symbol 或自定义图片)
            let img = NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: nil)
            img?.isTemplate = true  // 让系统可自动变暗 / 变亮
            imageView.image = img
            
            // 隐藏进度指示器
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(nil)
            
            // 1.5 秒后自动回到 normal
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
