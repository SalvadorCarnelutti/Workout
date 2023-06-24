//
//  StyledButton.swift
//  Workout
//
//  Created by Salvador on 6/5/23.
//

import UIKit

class StyledButton: UIButton {
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let horizontalPaddingInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        
        var enabledConfig = UIButton.Configuration.filled()
        enabledConfig.contentInsets = horizontalPaddingInsets
        
        var disabledConfig = UIButton.Configuration.gray()
        disabledConfig.contentInsets = horizontalPaddingInsets
        
        configuration = disabledConfig
        configurationUpdateHandler = { button in
            button.configuration = button.isEnabled ? enabledConfig : disabledConfig
            button.configuration?.title = button.title(for: .normal)
        }        
    }
}
