import UIKit
import Firebase
import FirebaseAuth
import UPCarouselFlowLayout
import ZoomTransition

var sheets = [Sheet]()
var sheetIndex = 0

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ZoomTransitionProtocol {
    @IBOutlet weak var selectedImage: UIImageView!
    var animationController : ZoomTransition!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var userId = Auth.auth().currentUser?.uid as! String
    var path = String()
    var titleName = String()
    
    
    var currentPage : Int {
        get{
            return pageControl.currentPage
        }
        set{
            pageControl.currentPage = newValue
        }
    }
    
    func viewForTransition() -> UIView {
        return selectedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = titleName
        
        if #available(iOS 11.0, *), UIDevice.current.userInterfaceIdiom == .phone{
            navigationItem.largeTitleDisplayMode = .always
            
            if(titleName == "Fundo de olho normal"){
                self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
            }
             else if(titleName == "Retinopatia diabética proliferativa"){
                self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            }
            else if(titleName == "Imagens de Retinopatia diabética"){
                self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
            }
            
            
            else{
                self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            }
            
        } else {
            navigationItem.title = titleName
        }

        sheets = [Sheet]()
        sheetIndex = 0
        
        getSheets()
        
        let height = collectionView!.bounds.height*0.75
        let width = height*0.7
        
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: width/10)
        layout.itemSize = CGSize(width:width, height:height)
        layout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCollectionViewLayout()
    }
    
    func getSheets(){
        
        
        firebaseRef!.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChildren(){
                
                let sheetDict = snapshot.value as? NSDictionary
                print("sheet \(sheetDict)")
                
                for key in 1...(sheetDict!.allKeys.count){
                    
                    sheets.append(Sheet(sheetDict!["image\(key)"] as! NSDictionary))
                }
                
                self.collectionView?.reloadData()
            }
            else{
                sheets = []
                self.collectionView?.reloadData()
            }
            self.pageControl.numberOfPages = sheets.count
            
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    func removeWhite(_ image: UIImage) -> UIImage {
        let rawImage = image.cgImage
        
        let colorMasking : [CGFloat] = [222, 255, 222, 255, 222, 255]
        return UIImage(cgImage: rawImage!.copy(maskingColorComponents: colorMasking)! )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       sheetIndex = indexPath.row
    
       performSegue(withIdentifier: "showSheetInfo", sender: nil)
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sheets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sheet", for: indexPath) as! SheetCollectionViewCell
        let row = indexPath.row
        let sheet = sheets[row]
        let image = UIImage(named: sheet.image)!
        
        cell.backgroundImageView?.image = image
        cell.customTitle.text = sheet.name//NSLocalizedString(sheet.altName, comment: "")
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            
        }) { (context) in
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, animations: {
                self.collectionView?.alpha = 0
            }, completion: { (finished) in
                self.updateCollectionViewLayout()
                UIView.animate(withDuration: 0.25, animations: {
                    self.collectionView?.alpha = 1
                })
            })
            
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let i = sender as! Int
//        let destination = segue.destination as! SheetInfoController
//
//        destination.i = i
//        /*
//        let sheet = sender as! Sheet
//
//        let destination = segue.destination as! SheetInfoController
//        destination.discription = sheet.discription
//        destination.image = UIImage(named: sheet.image)!*/
//    }
    
    func updateCollectionViewLayout() {
        
        
        
        if currentPage > 0 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }
        
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}

class SheetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var customTitle: UILabel!
    //@IBOutlet weak var customSubTitle: UILabel!
    
}
