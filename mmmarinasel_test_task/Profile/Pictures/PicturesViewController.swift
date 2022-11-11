import UIKit

class PicturesViewController: UIViewController {

    private var picturesCollectionView: UICollectionView?
    
    private let cellId: String = "pictureCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        layout.itemSize = CGSize(width: 60, height: 60)
        
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
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId,
                                                      for: indexPath)
        cell.backgroundColor = .cyan
        return cell
    }
    
}
