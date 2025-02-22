//
//  TabBarController.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 21.02.25.
//

import UIKit

protocol TabBarConfigurator {
    func configure() -> [UIViewController]
}

protocol TabBarIconConfigurator {
    func configureIcons(for tabBar: UITabBar)
}

class DefaultTabBarConfigurator: TabBarConfigurator {
    func configure() -> [UIViewController] {
        let photoGalleryViewModel: PhotoGalleryViewModelProtocol = PhotoGalleryViewModel()
        let photoGalleryVC = UINavigationController(
            rootViewController: PhotoGalleryViewController(viewModel: photoGalleryViewModel)
        )
        photoGalleryVC.tabBarItem = UITabBarItem(
            title: nil,
            image: nil,
            tag: 0
        )
        
        let settingsViewModel = SettingsViewModel()
        let settingsVC = UINavigationController(
            rootViewController: SettingsViewController(viewModel: settingsViewModel)
        )
        settingsVC.tabBarItem = UITabBarItem(
            title: nil,
            image: nil,
            tag: 1
        )
        
        return [photoGalleryVC, settingsVC]
    }
}

class DefaultTabBarIconConfigurator: TabBarIconConfigurator {
    func configureIcons(for tabBar: UITabBar) {
        guard let items = tabBar.items else { return }
        
        let iconSize = CGSize(width: 32, height: 32)
        let houseImage = UIImage(named: "icons8-tab-bar-image")?.resized(to: iconSize)
        let gearImage = UIImage(named: "icons8-tab-bar-settings")?.resized(to: iconSize)
        
        items[0].image = houseImage?.withRenderingMode(.alwaysTemplate)
        items[1].image = gearImage?.withRenderingMode(.alwaysTemplate)
    }
}


class TabBarController: UITabBarController {
    private let configurator: TabBarConfigurator
    private let iconConfigurator: TabBarIconConfigurator
    
    init(
        configurator: TabBarConfigurator,
        iconConfigurator: TabBarIconConfigurator
    ) {
        self.configurator = configurator
        self.iconConfigurator = iconConfigurator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureIcons()
        configureTabBarAppearance()
    }

    private func configureTabBar() {
        let viewControllers = configurator.configure()
        self.viewControllers = viewControllers
    }
    
    private func configureIcons() {
        iconConfigurator.configureIcons(for: self.tabBar)
    }
    
    private func configureTabBarAppearance() {
        self.tabBar.backgroundColor = Theme.backgroundNavigationBarPrimary
        self.tabBar.tintColor = Theme.navigationBackground
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .selected
        )
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.lightGray],
            for: .normal
        )
    }
}

