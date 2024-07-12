//
//  ExamplesListViewController.swift
//  Example
//
//  Created by Pavel Moslienko on 12.07.2024.
//

import UIKit
import ACMedia

final class ExamplesListViewController: UIViewController {
    
    var model: ExamplesListViewModel = ExamplesListViewModel()
    
    // MARK: - UI components
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        return stackView
    }()
    
    lazy var colorSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        AppColors.allCases.forEach({ color in
            segmentedControl.insertSegment(withTitle: color.name, at: color.rawValue, animated: true)
        })
        segmentedControl.selectedSegmentIndex = model.selectedColor.rawValue
        segmentedControl.addTarget(self, action: #selector(self.colorSegmentedControlDidChanged(_:)), for: .valueChanged)
        
        return segmentedControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Example"
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        
        self.view.addSubview(tableView)
        self.view.addSubview(footerStackView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(greaterThanOrEqualTo: self.footerStackView.topAnchor, constant: 8.0),
            
            footerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0),
            footerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0),
            footerStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        footerStackView.addArrangedSubview(colorSegmentedControl)
        
        tableView.reloadData()
    }
}

// MARK: - Module methods
private extension ExamplesListViewController {
    
    func handleExample(_ example: ExampleType) {
        switch example {
        case .singlePhoto:
            openSingleImagePicker()
        case .singleDoc:
            openFilesPicker()
        case .multiplePhotoAndDocs:
            openImageAndFilesPicker()
        }
    }
    
    func openSingleImagePicker() {
        var configuration = ACMediaConfiguration()
        configuration.photoConfig.allowCamera = false
        configuration.appearance = ACMediaAppearance(
            colors: ACMediaColors(tintColor: model.selectedColor.color)
        )
        
        let tabbarController = ACTabBarController(
            configuration: configuration,
            photoViewController: ACPhotoNavigationController(
                configuration: configuration,
                didPickAssets: { [weak self] assets in
                    self?.resetSelectedAssets()
                    self?.didPickImages(assets.images)
                    self?.didPickDocuments(assets.videoUrls)
                },
                didOpenSettings: { [weak self] in
                    self?.openSystemSettings()
                }
            )
        )
        
        self.present(tabbarController, animated: true)
    }
    
    func openImageAndFilesPicker() {
        var configuration = ACMediaConfiguration()
        configuration.photoConfig.allowCamera = false
        configuration.appearance = ACMediaAppearance(
            colors: ACMediaColors(tintColor: model.selectedColor.color)
        )
        configuration.photoConfig = ACMediaPhotoPickerConfig(types: [.photo, .video], limiter: .limit(min: 2, max: 4))
        configuration.documentsConfig = ACMediaDocumentConfig(fileFormats: [.zip])
        
        let tabbarController = ACTabBarController(
            configuration: configuration,
            photoViewController: ACPhotoNavigationController(
                configuration: configuration,
                didPickAssets: { [weak self] assets in
                    self?.resetSelectedAssets()
                    self?.didPickImages(assets.images)
                    self?.didPickDocuments(assets.videoUrls)
                },
                didOpenSettings: { [weak self] in
                    self?.openSystemSettings()
                }
            ),
            documentsViewController: ACDocumentPickerViewController.create(
                configuration: configuration,
                didPickDocuments: { [weak self] fileUrls in
                    self?.resetSelectedAssets()
                    self?.didPickDocuments(fileUrls)
                }
            )
        )
        
        self.present(tabbarController, animated: true)
    }
    
    func openFilesPicker() {
        var configuration = ACMediaConfiguration()
        configuration.appearance = ACMediaAppearance(
            colors: ACMediaColors(tintColor: model.selectedColor.color)
        )
        configuration.documentsConfig = ACMediaDocumentConfig(fileFormats: [.pdf])
        
        let tabbarController = ACTabBarController(
            configuration: configuration,
            documentsViewController: ACDocumentPickerViewController.create(
                configuration: configuration,
                didPickDocuments: { [weak self] fileUrls in
                    self?.didPickDocuments(fileUrls)
                }
            )
        )
        
        self.present(tabbarController, animated: true)
    }
    
    
    func openSystemSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    func resetSelectedAssets() {
        model.images = []
        model.files = []
    }
    
    @objc
    func colorSegmentedControlDidChanged(_ segmentedControl: UISegmentedControl) {
        print("segmentedControl - \(segmentedControl.selectedSegmentIndex)")
        guard let color = AppColors(rawValue: segmentedControl.selectedSegmentIndex) else {
            return
        }
        model.selectedColor = color
        tableView.reloadData()
    }
}


// MARK: - Handle picker result
private extension ExamplesListViewController {
    
    func didPickDocuments(_ urls: [URL]) {
        print("onPickDocuments - \(urls)")
        model.files = urls
        tableView.reloadData()
    }
    
    func didPickImages(_ images: [UIImage]) {
        print("didSelect - \(images.count)")
        model.images = images
        tableView.reloadData()
    }
}
// MARK: - UITableViewDataSource
extension ExamplesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return model.images.count
        case 2:
            return model.files.count
        default:
            return model.examples.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.textLabel?.textColor = model.selectedColor.color
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.numberOfLines = 0
        
        switch indexPath.section {
        case 1:
            let image = model.images[indexPath.row]
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addSubview(imageView)
            
            imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
            
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .none
        case 2:
            let url = model.files[indexPath.row]
            
            cell.textLabel?.text = url.lastPathComponent
            cell.detailTextLabel?.text = nil
            cell.subviews.forEach({
                if $0 is UIImageView {
                    $0.removeFromSuperview()
                }
            })
            cell.accessoryType = .none
        default:
            let rule = model.examples[indexPath.row]
            
            cell.textLabel?.text = rule.title
            cell.detailTextLabel?.text = rule.subtitle
            cell.subviews.forEach({
                if $0 is UIImageView {
                    $0.removeFromSuperview()
                }
            })
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            return
        }
        let example = model.examples[indexPath.row]
        handleExample(example)
    }
}

// MARK: - UITableViewDataSource
extension ExamplesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 100.0
        default:
            return UITableView.automaticDimension
        }
    }
}
