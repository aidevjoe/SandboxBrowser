//
//  SandboxBrowser.swift
//  SandboxBrowser
//
//  Created by Joe on 2017/8/25.
//  Copyright © 2017年 Joe. All rights reserved.
//

import Foundation
import UIKit

public enum FileType: String {
    case directory = "directory"
    case gif = "gif"
    case jpg = "jpg"
    case png = "png"
    case jpeg = "jpeg"
    case json = "json"
    case pdf = "pdf"
    case plist = "plist"
    case file = "file"
    case sqlite = "sqlite"
    case log = "log"
    
    var fileName: String {
        switch self {
        case .directory: return "directory"
        case .jpg, .pdf, .gif, .jpeg: return "image"
        case .plist: return "plist"
        case .sqlite: return "sqlite"
        case .log: return "log"
        default: return "file"
        }
    }
}

public struct FileItem {
    public var name: String
    public var path: String
    public var type: FileType
    
    public var modificationDate: Date {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            return attr[FileAttributeKey.modificationDate] as? Date ?? Date()
        } catch {
            print(error)
            return Date()
        }
    }
    
    var image: UIImage {
        let bundle = Bundle(for: FileListViewController.self)
        let path = bundle.path(forResource: "Resources", ofType: "bundle")
        let resBundle = Bundle(path: path!)!
        
        return UIImage(contentsOfFile: resBundle.path(forResource: type.fileName, ofType: "png")!)!
    }
}

public class SandboxBrowser: UINavigationController {
    
    var fileListVC: FileListViewController?
    
    open var didSelectFile: ((FileItem, FileListViewController) -> ())? {
        didSet {
            fileListVC?.didSelectFile = didSelectFile
        }
    }
    
    public convenience init() {
        self.init(initialPath: URL(fileURLWithPath: NSHomeDirectory()))
    }
    
    public convenience init(initialPath: URL) {
        let fileListVC = FileListViewController(initialPath: initialPath)
        self.init(rootViewController: fileListVC)
        self.fileListVC = fileListVC
    }
}

public class FileListViewController: UIViewController {
    
    fileprivate struct Misc {
        static let cellIdentifier = "FileCell"
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds)
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 70
        view.separatorInset = .zero
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        view.addGestureRecognizer(longPress)
        return view
    }()
    
    fileprivate var items: [FileItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var didSelectFile: ((FileItem, FileListViewController) -> ())?
    var initialPath: URL?
    
    public convenience init(initialPath: URL) {
        self.init()
        
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        loadPath(initialPath!.relativePath)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(close))
    }
    
    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        let item = items[indexPath.row]
        if item.type != .directory { shareFile(item.path) }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadPath(_ path: String = "") {
        var filelist = [FileItem]()
        
        var paths: [String] = []
        
        do {
            paths = try FileManager.default.contentsOfDirectory(atPath: path)
            guard paths.count > 0 else { return }
        } catch {
            print(error.localizedDescription)
        }
        
        paths.filter { !$0.hasPrefix(".") }.forEach { subpath in
            var isDir: ObjCBool = ObjCBool(false)
            
            let fullpath = path.appending("/" + subpath)
            FileManager.default.fileExists(atPath: fullpath, isDirectory: &isDir)
            
            var pathExtension = URL(fileURLWithPath: fullpath).pathExtension.lowercased()
            if pathExtension.hasPrefix("sqlite") || pathExtension == "db" { pathExtension = "sqlite" }
            
            let filetype: FileType = isDir.boolValue ? .directory : FileType(rawValue: pathExtension) ?? .file
            let fileItem = FileItem(name: subpath, path: fullpath, type: filetype)
            filelist.append(fileItem)
        }
        items = filelist
    }
    
    func shareFile(_ filePath: String) {
        
        let controller = UIActivityViewController(
            activityItems: [NSURL(fileURLWithPath: filePath)],
            applicationActivities: nil)
        
        controller.excludedActivityTypes = [
            .postToTwitter, .postToFacebook, .postToTencentWeibo, .postToWeibo,
            .postToFlickr, .postToVimeo, .message, .addToReadingList,
            .print, .copyToPasteboard, .assignToContact, .saveToCameraRoll,
        ]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5, width: 10, height: 10)
        }
        if (self.presentedViewController == nil) {
            // The "if" test prevents "Warning: Attempt to present UIActivityViewController:...
            // on which is already presenting" warning messages from occurring.
            self.present(controller, animated: true, completion: nil)
        }
    }
}

class FileCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var imageFrame = imageView!.frame
        imageFrame.size.width = 55
        imageFrame.size.height = 55
        imageView?.frame = imageFrame
        imageView?.center.y = contentView.center.y
        
        var textLabelFrame = textLabel!.frame
        textLabelFrame.origin.x = imageFrame.maxX + 15
        textLabelFrame.origin.y = textLabelFrame.origin.y - 5
        textLabel?.frame = textLabelFrame
        
        var detailLabelFrame = detailTextLabel!.frame
        detailLabelFrame.origin.x = textLabelFrame.origin.x
        detailLabelFrame.origin.y = detailLabelFrame.origin.y + 5
        detailTextLabel?.frame = detailLabelFrame
    }
}

extension FileListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Misc.cellIdentifier)
        if cell == nil { cell = FileCell(style: .subtitle, reuseIdentifier: Misc.cellIdentifier) }
        
        let item = items[indexPath.row]
        cell?.textLabel?.text = item.name
        cell?.imageView?.image = item.image
        cell?.detailTextLabel?.text = DateFormatter.localizedString(from: item.modificationDate,
                                                                    dateStyle: .medium,
                                                                    timeStyle: .medium)
        cell?.accessoryType = item.type == .directory ? .disclosureIndicator : .none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < items.count else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        
        switch item.type {
        case .directory:
            let sandbox = FileListViewController(initialPath: URL(fileURLWithPath: item.path))
            sandbox.didSelectFile = didSelectFile
            self.navigationController?.pushViewController(sandbox, animated: true)
        default:
            didSelectFile?(item, self)
        }
    }
}
