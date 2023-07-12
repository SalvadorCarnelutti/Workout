//
//  ToggleImageView.swift
//  Workout
//
//  Created by Salvador on 7/10/23.
//

import UIKit

struct ToggleImageModel {
    var asDefault: Bool
    var defaultImage: UIImage
    var defaultBackgroundColor: UIColor
    var alternateImage: UIImage
    var alternateBackgroundColor: UIColor
}

class ToggleImageView: UIImageView {
    private var asDefault: Bool = true
    var defaultImage: UIImage?
    var defaultBackgroundColor: UIColor?
    var alternateImage: UIImage?
    var alternateBackgroundColor: UIColor?
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        addSubview(containerView)
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with toggleImageModel: ToggleImageModel) {
        self.asDefault = toggleImageModel.asDefault
        self.defaultImage = toggleImageModel.defaultImage
        self.defaultBackgroundColor = toggleImageModel.defaultBackgroundColor
        self.alternateImage = toggleImageModel.alternateImage
        self.alternateBackgroundColor = toggleImageModel.alternateBackgroundColor
        
        updateImageView()
    }
    
    func toggle() {
        asDefault.toggle()
        updateImageView()
    }
    
    private func commonInit() {
        setupConstraints()
    }
    
    private func updateImageView() {
        updateBackgroundColor()
        updateImage()
    }
    
    private func updateImage() {
        guard let transitionToImage: UIImage = asDefault ? defaultImage : alternateImage else { return }
        imageView.setSymbolImage(transitionToImage, contentTransition: .replace)
    }
    
    private func updateBackgroundColor() {
        containerView.backgroundColor = asDefault ? defaultBackgroundColor : alternateBackgroundColor
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}
