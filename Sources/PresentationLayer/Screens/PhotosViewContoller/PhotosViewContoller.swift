//
//  PhotosViewContoller.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

internal final class PhotoGridViewController: UIViewController {
    
    private var viewModel = PhotosViewModel()
    private let captureSession = AVCaptureSession()

    // MARK: - Components
    private lazy var doneButton: UIBarButtonItem = {
        let done = UIBarButtonItem(
            title: String.locale(for: "Done"),
            style: .done,
            target: self,
            action: #selector(doneAction))
        done.tintColor = ACMediaConfiguration.shared.appearance.tintColor
        return done
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let done = UIBarButtonItem(
            title: String.locale(for: "Cancel"),
            style: .plain,
            target: self,
            action: #selector(cancelAction))
        done.tintColor = ACMediaConfiguration.shared.appearance.tintColor
        return done
    }()
    
    // MARK: - Params
    private var topSpacing: CGFloat = 5
    private var bottomSpacing: CGFloat = 5
    private var leftSpacing: CGFloat = 5
    private var rightSpacing: CGFloat = 5
    private var interSpacing: CGFloat {
        ACMediaConfig.appearance.gridSpacing
    }
    
    private var cellWidth: CGFloat {
        let itemsInRow = CGFloat(ACMediaConfig.appearance.cellsInRow)
        
        let spacing: CGFloat = leftSpacing + rightSpacing + 2 * interSpacing
        let cellWidth = (collectionView.frame.width - spacing) / itemsInRow
        return cellWidth
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = interSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 10,
            left: leftSpacing,
            bottom: bottomSpacing,
            right: rightSpacing)
        
        let collectionView = UICollectionView(
            frame: self.view.frame,
            collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // The description is used to tell the user how many images he needs or can choose.
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ACMediaConfig.appearance.foregroundColor
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        return label
    }()
    
    
    @available(iOSApplicationExtension 13.0, *)
    var demoMenu: UIMenu {
        var menuItems: [UIAction] {
            return self.viewModel.albumsData.map({ albumModel in
                if #available(iOSApplicationExtension 15.0, *) {
                    return UIAction(title: albumModel.title, subtitle: String(albumModel.count), image: albumModel.previewImage, handler: { (_) in
                        self.viewModel.albumModel = albumModel
                        DispatchQueue.main.async {
                            self.reloadData()
                        }
                    })
                } else {
                    return UIAction(title: albumModel.title, image: albumModel.previewImage, handler: { (_) in
                        self.viewModel.albumModel = albumModel
                        DispatchQueue.main.async {
                            self.reloadData()
                        }
                    })
                }
            })
        }
        
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    
    private func checkDoneButtonCondition() {
        let isSelectionRequired = false
        let selectionLimit = 1
        
        var isEnabled: Bool
        if isSelectionRequired {
            isEnabled = SelectedImagesStack.shared.selectedCount == selectionLimit
        } else {
            isEnabled = SelectedImagesStack.shared.selectedCount > 0
        }
        print("ssss \(SelectedImagesStack.shared.selectedCount)")
        doneButton.isEnabled = isEnabled
    }
    
    // MARK: - Actions
    @objc private func cancelAction() {
        SelectedImagesStack.shared.deleteAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneAction() {
        guard SelectedImagesStack.shared.selectedCount > 0 else {
            cancelAction()
            return
        }
        
        DispatchQueue.main.async { [unowned self] in
            let assets = SelectedImagesStack.shared.fetchAssets()
            SelectedImagesStack.shared.deleteAll()
            
            let manager = PhotoService()
            manager.fileTypes = ACMediaConfiguration.shared.photoConfig.types
            let images: [UIImage] = manager.fetchHighResImages(for: assets)
            
            (self.navigationController as? MainNavigationController)?.imageSelectorDelegate?.didSelect(images: images)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        
        view.backgroundColor = .white
        configureToolbar()
        configureCollectionView()
        configureDescriptionLabel()
        
        viewModel.onReloadCollection = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionView.reloadData()
            
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    strongSelf.setupCamera()
                }
            }
        }
        viewModel.onShowPermissionAlert = { [weak self] in
            self?.showPermissionAlert()
        }
        viewModel.onShowEmptyPlaceholder = { [weak self] in
            self?.showEmptyAlbumLabel()
        }
        viewModel.onSetupNavbar = { [weak self] in
            self?.setupNavbar()
        }
        viewModel.onShowImageOnFullScreen = { [weak self] asset in
            self?.presentImageDetailsViewController(with: asset)
        }
        viewModel.onShowCamera = { [weak self] in
            self?.showCamera()
        }
        viewModel.onReloadCells = { [weak self] indexes in
            self?.collectionView.reloadItems(at: indexes )
        }
        viewModel.onSetupDoneButton = { [weak self] in
            self?.checkDoneButtonCondition()
        }
        reloadData()
    }
    
    func reloadData() {
        if let model = viewModel.albumModel {
            viewModel.imagesData = model.assets
            if viewModel.imagesData.count == 0 {
                showEmptyAlbumLabel()
            }
        }
        
        setupNavbar()
        checkDoneButtonCondition()
        viewModel.reloadData()
    }
    
    func setupNavbar() {
        let button = UIButton(type: .system)
        var icon = AppAssets.Icon.downArrow.image?.withRenderingMode(.alwaysTemplate)
        
        let targetSize = CGSize(width: 17, height: 17)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        icon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        button.setImage(icon, for: .normal)
        button.setTitle(self.viewModel.albumModel?.title ?? "-", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.sizeToFit()
        
        button.setTitleColor(.black, for: [])
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 17.0)
        button.tintColor = .black
        
        if #available(iOSApplicationExtension 14.0, *) {
            button.menu = demoMenu
            button.showsMenuAsPrimaryAction = true
        } else {
            button.addTarget(self, action: #selector(self.showPhotoAlbumsAlert), for: .touchUpInside)
        }
        
        self.navigationItem.leftBarButtonItem = self.cancelButton
        self.navigationItem.titleView = button
        self.navigationItem.rightBarButtonItem = self.doneButton
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func showEmptyAlbumLabel() {
        collectionView.isHidden = true
        
        let label = UILabel()
        label.text = String.locale(for: "EmptyAlbumLabel")
        label.textColor = ACMediaConfig.appearance.foregroundColor
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        let constraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func showPermissionAlert() {
        let title = String.locale(for: "PermissionRequired")
        let message = String.locale(for: "PermissionRequiredDescription")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsTitle = String.locale(for: "Settings")
        let settingsAction = UIAlertAction(title: settingsTitle, style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
#warning("todo open settings")
            //            if UIApplication.shared.canOpenURL(settingsURL) {
            //                UIApplication.shared.open(settingsURL)
            //            }
        }
        
        let cancelTitle = String.locale(for: "Cancel")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func configureToolbar() {
        navigationController?.isToolbarHidden = false
        toolbarItems = navigationController?.toolbarItems
    }
    
    private func configureCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCardCell")
        collectionView.register(CameraCell.self, forCellWithReuseIdentifier: "CameraCell")
        view.addSubview(collectionView)
        
        let guide = view.safeAreaLayoutGuide
        let constraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            guide.rightAnchor.constraint(equalTo: collectionView.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func configureDescriptionLabel() {
        view.addSubview(descriptionLabel)
        
        var labelHeight: CGFloat = 28
        let selectionLimit = ACMediaConfig.photoConfig.selectionLimit
        
        if selectionLimit == 1 {
            descriptionLabel.isHidden = true
            labelHeight = 0
        } else {
            let isSelectionRequired = ACMediaConfig.photoConfig.isSelectionRequired
            if isSelectionRequired {
                let localizedString = String.locale(for: "Require")
                descriptionLabel.text = String(format: localizedString, selectionLimit)
            } else {
                let localizedString = String.locale(for: "Selected")
                descriptionLabel.text = String(format: localizedString, selectionLimit)
            }
        }
        
        let guide = view.safeAreaLayoutGuide
        let constraints: [NSLayoutConstraint] = [
            descriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: guide.leftAnchor),
            guide.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            guide.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func presentImageDetailsViewController(with asset: PHAsset) {
        viewModel.photoService.fetchThumbnail(for: asset, size: CGSize()) { [unowned self] image in
            guard let image = image else {
                return
            }
            let details = PhotoPreviewViewController()
            details.image = image
            details.asset = asset
            
            let viewWidth = view.frame.size.width
            let viewHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let ratio = image.size.width / image.size.height
            
            details.portraitConstraint = viewWidth / ratio
            details.landscapeConstraint = viewHeight * ratio
            
            DispatchQueue.main.async {
                guard self.navigationController?.topViewController == self else { return }
                self.navigationController?.pushViewController(details, animated: true)
            }
        }
    }
    
    @objc
    private func showPhotoAlbumsAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: String.locale(for: "Cancel"), style: .cancel)
        
        self.viewModel.albumsData.forEach({ albumModel in
            alert.addAction(
                UIAlertAction(title: albumModel.title, style: .default) { _ in
                    self.viewModel.albumModel = albumModel
                    DispatchQueue.main.async {
                        self.reloadData()
                    }
                })
        })
        
        alert.addAction(cancel)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            
            self.present(alert, animated:true, completion: nil)
        }
    }
    
    private func showCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func setupCamera() {
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.main.async {
            guard let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CameraCell else {
                return
            }
            cell.addCameraLayer(previewLayer)
        }
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                self.captureSession.addInput(input)
            } catch {
                print(error.localizedDescription)
            }
        }
                        
        DispatchQueue(label: "ACMedia.CameraThread", attributes: .concurrent).async {
            self.captureSession.startRunning()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoGridViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        (self.navigationController as? MainNavigationController)?.imageSelectorDelegate?.didSelect(images: [image])
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension PhotoGridViewController: UINavigationControllerDelegate {}

// MARK: - UICollectionViewDataSource
extension PhotoGridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCell else { return }
        
        let updateCellClosure: (UIImage?) -> Void = { [unowned self] image in
            (self.viewModel.models[indexPath.row - 1] as? PhotoCellModel)?.image = image
            cell.updateThumbImage(image)
            self.viewModel.loadingOperations.removeValue(forKey: indexPath)
        }
        
        if let dataLoader = viewModel.loadingOperations[indexPath] {
            if let image = dataLoader.img {
                (self.viewModel.models[indexPath.row - 1] as? PhotoCellModel)?.image = image
                cell.updateThumbImage(image)
                viewModel.loadingOperations.removeValue(forKey: indexPath)
            } else {
                dataLoader.onFinishLoadingImage = updateCellClosure
            }
        } else {
            let model = viewModel.imagesData[indexPath.item - 1]
            let size = CGSize(width: cellWidth, height: cellWidth)
            if let dataLoader = AsyncImageLoader.fetchImage(from: model, withSize: size) {
                dataLoader.onFinishLoadingImage = updateCellClosure
                viewModel.loadingQueue.addOperation(dataLoader)
                viewModel.loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row != 0 else {
            return
        }
        if let dataLoader = viewModel.loadingOperations[indexPath] {
            dataLoader.cancel()
            viewModel.loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.viewModel.models[indexPath.row]
        
        if let model = model as? CameraCellModel {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CameraCell",
                for: indexPath) as? CameraCell
            else {
                return UICollectionViewCell()
            }
            cell.cellModel = model
            return cell
        } else if let model = model as? PhotoCellModel {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PhotoCardCell",
                for: indexPath) as? PhotoCell
            else {
                return UICollectionViewCell()
            }
            cell.cellModel = model
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension PhotoGridViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row != 0 else {
                return
            }
            if viewModel.loadingOperations[indexPath] != nil { return }
            
            let model = viewModel.imagesData[indexPath.item - 1]
            let size = CGSize(width: cellWidth, height: cellWidth)
            if let dataLoader = AsyncImageLoader.fetchImage(from: model, withSize: size) {
                viewModel.loadingQueue.addOperation(dataLoader)
                viewModel.loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row != 0 else {
                return
            }
            
            if let dataLoader = viewModel.loadingOperations[indexPath] {
                dataLoader.cancel()
                viewModel.loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoGridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: cellWidth, height: cellWidth)
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PhotoGridViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async { [unowned self] in
            viewModel.authorize()
        }
    }
}

// MARK: - ZoomingViewController
extension PhotoGridViewController: ZoomTransitionViewController {
    
    func getZoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        if let indexPath =  viewModel.selectedIndexPath,
           indexPath.row != 0,
           let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            return cell.getPreviewImageView()
        } else {
            return nil
        }
    }
}
