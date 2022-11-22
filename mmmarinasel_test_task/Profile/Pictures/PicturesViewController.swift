import UIKit

class PicturesViewController: UIViewController {

    private var picturesCollectionView: UICollectionView?
    
    private let urlString: String = "https://api.unsplash.com/photos/?client_id=RDTgAwXSjpgiUCmhnvEhTqQ-lYoE7FGHg2aGJo0vGEQ"
    
    private let cellId: String = "pictureCell"
    private let verticalPadding: Double = 20
    private let horizontalPadding: Double = 10
    
    var pictures: [PictureModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.getPicturesJson(urlString: self.urlString) { [weak self] data in
            self?.pictures.append(contentsOf: data)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildView()
    }
    
    func buildView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20,
                                           left: 10,
                                           bottom: 10,
                                           right: 10)
        let sideSize: Double = Double(self.view.frame.width) / 3 - 1.5 * self.horizontalPadding
        layout.itemSize = CGSize(width: sideSize,
                                 height: sideSize)
        
        self.picturesCollectionView = UICollectionView(frame: self.view.frame,
                                                       collectionViewLayout: layout)
        self.picturesCollectionView?.register(PictureCollectionViewCell.self,
                                              forCellWithReuseIdentifier: self.cellId)
        
        self.view.addSubview(self.picturesCollectionView ?? UICollectionView())
        
        self.picturesCollectionView?.delegate = self
        self.picturesCollectionView?.dataSource = self
    }
}

extension PicturesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped")
    }
}

extension PicturesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId,
                                                            for: indexPath) as? PictureCollectionViewCell
        else { return PictureCollectionViewCell() }
        cell.backgroundColor = .systemMint
        cell.setImage(nil)
        NetworkManager.loadImageFromURL(urlString: self.pictures[indexPath.row].urls.small) { img in
//            print(self?.pictures[indexPath.row].urls.small)
            cell.setImage(img)
            
//            self?.picturesCollectionView?.reloadData()
        }
        return cell
    }
    
}
