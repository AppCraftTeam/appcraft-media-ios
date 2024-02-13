//
//  PhotoGridViewController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import DPUIKit
import PhotosUI
import UIKit

public final class PhotoGridViewController: UIViewController {
    
    private var viewModel = PhotosViewModel()
    // Session for camera preview
    private let captureSession = AVCaptureSession()
    
    // MARK: - Components
    private lazy var doneButton: UIBarButtonItem = {
        let done = UIBarButtonItem(
            title: AppLocale.done.locale,
            style: .done,
            target: self,
            action: #selector(doneAction))
        done.tintColor = ACMediaConfiguration.shared.appearance.tintColor
        return done
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let done = UIBarButtonItem(
            title: AppLocale.cancel.locale,
            style: .plain,
            target: self,
            action: #selector(cancelAction))
        done.tintColor = ACMediaConfiguration.shared.appearance.tintColor
        return done
    }()
    
    private lazy var collectionView: DPCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 10,
            left: leftSpacing,
            bottom: bottomSpacing,
            right: rightSpacing
        )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = interSpacing
        
        let result = DPCollectionView(frame: .zero, collectionViewLayout: layout)
        result.prefetchDataSource = self
        
        result.adapter = DPCollectionAdapter(
            itemAdapters: [
                PhotoCell.Adapter(
                    onSizeForItem: { [weak self] ctx in
                        guard let self else { return nil }
                        return CGSize(width: self.cellWidth, height: self.cellWidth)
                    }
                ),
                CameraCell.Adapter(
                    onSizeForItem: { [weak self] ctx in
                        guard let self else { return nil }
                        return CGSize(width: self.cellWidth, height: self.cellWidth)
                    }
                )
            ],
            supplementaryAdapters: []
        )
        
        result.adapter?.willDisplayItem = { [weak self] data in
            self?.handleWillDispayCellEvent(data: data)
        }
        
        result.adapter?.didEndDisplayingItem = { [weak self] data in
            self?.handleDidEndDisplayingCellEvent(data: data)
        }
        
        return result
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
        let cellWidth = (self.view.frame.width - spacing) / itemsInRow
        return cellWidth
    }
    
    @available(iOS 13.0, *)
    private var albumsListMenu: UIMenu {
        var menuItems: [UIAction] {
            self.viewModel.albumsData.map({ albumModel in
                if #available(iOS 15.0, *) {
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
    
    // MARK: - Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        
        view.backgroundColor = ACMediaConfiguration.shared.appearance.backgroundColor
        configureToolbar()
        configureCollectionView()
        
        viewModel.onReloadCollection = { [weak self] sections in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionView.adapter?.reloadData(sections)
            
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
            self?.showEmptyPlaceholder()
        }
        viewModel.onHideEmptyPlaceholder = { [weak self] in
            self?.hideEmptyPlaceholder()
        }
        viewModel.onSetupNavbar = { [weak self] in
            self?.setupNavbar()
        }
        viewModel.onShowImageOnFullScreen = { [weak self] asset in
            self?.presentImageDetailsViewController(with: asset)
        }
        viewModel.onShowCamera = { [weak self] in
#if TARGET_IPHONE_SIMULATOR
#else
            self?.showCamera()
#endif
        }
        viewModel.onReloadCells = { [weak self] indexes in
            self?.collectionView.adapter?.reloadData(self?.viewModel.sections ?? [])
        }
        viewModel.onSetupDoneButton = { [weak self] in
            self?.checkDoneButtonCondition()
        }
        reloadData()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Module methods
private extension PhotoGridViewController {
    
    func reloadData() {
        if let model = viewModel.albumModel {
            viewModel.imagesData = model.assets
            // swiftlint:disable:next empty_count
            if viewModel.imagesData.count == 0 {
                showEmptyPlaceholder()
            } else {
                hideEmptyPlaceholder()
            }
        }
        
        setupNavbar()
        checkDoneButtonCondition()
        viewModel.reloadData()
    }
    
    /// Show photo preview VC
    /// - Parameter asset: Photo asset
    func presentImageDetailsViewController(with asset: PHAsset) {
        viewModel.photoService.fetchThumbnail(for: asset, size: CGSize()) { [unowned self] _ in
            let vc = PhotoPreviewViewController()
            vc.viewModel = PhotoPreviewViewModel(asset: asset)
            
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                guard self.navigationController?.topViewController == self else { return }
                self.navigationController?.present(nav, animated: true)
            }
        }
    }
    
    /// Show placeholder
    func showEmptyPlaceholder() {
        collectionView.isHidden = true
        
        let label = UILabel()
        label.text = AppLocale.emptyAlbum.locale
        label.textColor = ACMediaConfig.appearance.foregroundColor
        label.font = ACMediaConfig.appearance.emptyAlbumFont
        
        view.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// Hide placeholder
    func hideEmptyPlaceholder() {
        view.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        collectionView.isHidden = false
    }
    
    /// Show an alert asking to allow photo access in the settings
    func showPermissionAlert() {
        let title = AppLocale.assetsPermissionTitle.locale
        let message = AppLocale.assetsPermissionMessage.locale
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsTitle = AppLocale.assetsPermissionOpenSettings.locale
        let settingsAction = UIAlertAction(title: settingsTitle, style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
            ((self?.navigationController as? MainNavigationController)?.acMediaService)?.didOpenSettings?()
        }
        
        let cancelTitle = AppLocale.cancel.locale
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    /// Setup controller toolbar
    func configureToolbar() {
        navigationController?.isToolbarHidden = false
        toolbarItems = navigationController?.toolbarItems
    }
    
    /// Setup collection view position on screen
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    /// Show camera picker VC
    func showCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    /// Setup camera preview
    func setupCamera() {
        guard ACMediaConfiguration.shared.photoConfig.allowCamera else {
            return
        }
        
        captureSession.beginConfiguration()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        captureSession.commitConfiguration()
        
        DispatchQueue(label: "ACMedia.CameraThread", attributes: .concurrent).async {
            self.captureSession.beginConfiguration()
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    /// Handling of the event of cell display begining with assertion
    /// - Parameter data: Collection cell data
    func handleWillDispayCellEvent(data: DPCollectionAdapter.ItemContext) {
        guard let cell = data.cell as? PhotoCell else { return }
        let indexPath = data.indexPath
        let rowIndexPath = indexPath.row
        let updateCellClosure: (UIImage?) -> Void = { [unowned self] image in
            (self.viewModel.sections[safeIndex: 0]?.items[rowIndexPath] as? PhotoCellModel)?.image = image
            cell.updateThumbImage(image)
            self.viewModel.loadingOperations.removeValue(forKey: indexPath)
        }
        // Trying to get a preview of the asset
        if let dataLoader = viewModel.loadingOperations[indexPath] {
            if let image = dataLoader.img {
                (self.viewModel.sections[safeIndex: 0]?.items[rowIndexPath] as? PhotoCellModel)?.image = image
                cell.updateThumbImage(image)
                viewModel.loadingOperations.removeValue(forKey: indexPath)
            } else {
                dataLoader.onFinishLoadingImage = updateCellClosure
            }
        } else {
            let model = viewModel.imagesData[rowIndexPath]
            let size = CGSize(width: cellWidth, height: cellWidth)
            if let dataLoader = AsyncImageLoader.fetchImage(from: model, withSize: size) {
                dataLoader.onFinishLoadingImage = updateCellClosure
                viewModel.loadingQueue.addOperation(dataLoader)
                viewModel.loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    /// Handling of the event of cell display finishing with assertion
    /// - Parameter data: Collection cell data
    func handleDidEndDisplayingCellEvent(data: DPCollectionAdapter.ItemContext) {
        guard data.cell as? PhotoCell != nil,
              let dataLoader = viewModel.loadingOperations[data.indexPath]
        else {
            return
        }
        // Cancel operation for getting asset preview
        dataLoader.cancel()
    }
    
    /// Changing the availability of the confirmation button depending on the number of selected assets
    func checkDoneButtonCondition() {
        let min = ACMediaConfiguration.shared.photoConfig.minimimSelection
        let max = ACMediaConfiguration.shared.photoConfig.maximumSelection
        
        var isEnabled: Bool {
            if let max = max {
                return SelectedImagesStack.shared.selectedCount <= max && SelectedImagesStack.shared.selectedCount >= min
            } else {
                return SelectedImagesStack.shared.selectedCount >= min
            }
        }
        
        doneButton.isEnabled = isEnabled
    }
    
    /// Setup controller navigation bar
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
        
        button.setTitleColor(ACMediaConfiguration.shared.appearance.foregroundColor, for: [])
        button.titleLabel?.textColor = ACMediaConfiguration.shared.appearance.foregroundColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 17.0)
        button.tintColor = ACMediaConfiguration.shared.appearance.foregroundColor
        
        if #available(iOS 14.0, *) {
            button.menu = albumsListMenu
            button.showsMenuAsPrimaryAction = true
        } else {
            button.addTarget(self, action: #selector(self.showPhotoAlbumsAlert), for: .touchUpInside)
        }
        
        self.navigationItem.leftBarButtonItem = self.cancelButton
        self.navigationItem.titleView = button
        self.navigationItem.rightBarButtonItem = self.doneButton
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoGridViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        // Return to the parent app user photo captured in the camera
        ((self.navigationController as? MainNavigationController)?.acMediaService)?.didPickAssets(PhotoPickerCallbackModel(images: [image], videoUrls: []))
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension PhotoGridViewController: UINavigationControllerDelegate {}

// MARK: - UICollectionViewDataSourcePrefetching
extension PhotoGridViewController: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard isNotCameraCell(on: indexPath) else {
                return
            }
            let rowIndexPath = ACMediaConfiguration.shared.photoConfig.allowCamera ? indexPath.row - 1 : indexPath.row
            if viewModel.loadingOperations[indexPath] != nil { return }
            
            let model = viewModel.imagesData[rowIndexPath]
            let size = CGSize(width: cellWidth, height: cellWidth)
            // Set fetching image preview operation
            if let dataLoader = AsyncImageLoader.fetchImage(from: model, withSize: size) {
                viewModel.loadingQueue.addOperation(dataLoader)
                viewModel.loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard isNotCameraCell(on: indexPath),
                  let dataLoader = viewModel.loadingOperations[indexPath] else {
                return
            }
            // Cancelling fetching image preview operation
            dataLoader.cancel()
            viewModel.loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    // To make sure it's an asset and not a preview camera.
    private func isNotCameraCell(on indexPath: IndexPath) -> Bool {
        if ACMediaConfiguration.shared.photoConfig.allowCamera {
            return indexPath.row != 0
        }
        return true
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PhotoGridViewController: PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async { [unowned self] in
            viewModel.authorize()
        }
    }
}

// MARK: - Actions
extension PhotoGridViewController {
    
    @objc
    private func cancelAction() {
        SelectedImagesStack.shared.deleteAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func doneAction() {
        guard SelectedImagesStack.shared.selectedCount > 0 else {
            cancelAction()
            return
        }
        
        DispatchQueue.main.async { [unowned self] in
            let assets = SelectedImagesStack.shared.fetchAssets()
            SelectedImagesStack.shared.deleteAll()
            
            let manager = PhotoService()
            manager.fileTypes = ACMediaConfiguration.shared.photoConfig.types
            
            // Get originals for selecting photos
            manager.fetchHighResImages(for: assets) { images in
                // Get paths for selecting videos
                manager.fetchVideoURL(for: assets) { videoUrls in
                    let model = PhotoPickerCallbackModel(images: images, videoUrls: videoUrls)
                    ((self.navigationController as? MainNavigationController)?.acMediaService)?.didPickAssets(model)
                }
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func showPhotoAlbumsAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: AppLocale.cancel.locale, style: .cancel)
        
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
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - ZoomingViewController
extension PhotoGridViewController: ZoomTransitionViewController {
    
    public func getZoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        if let indexPath = viewModel.selectedIndexPath,
           let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            // For previewing photo screen animation
            return cell.getPreviewImageView()
        } else {
            return nil
        }
    }
}
