import UIKit
import Social
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    // MARK: Propriedades
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var layoutConstraintCenterVertical: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    var viewModel : LoginViewModel!
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = LoginViewModel()
        }
        if #available(iOS 11.0, *) {
            //self.additionalSafeAreaInsets = UIEdgeInsetsMake(-64, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }
        textFieldEmail.autocorrectionType = .no
        textFieldEmail.autocapitalizationType = .none
        setupMotionEffect()
        self.groupView.layer.borderWidth = 1
        self.groupView.layer.borderColor = appMainColor.cgColor
        let inImage = imageViewLogo.image!
        
        //*3 por causa do @3x
        UIGraphicsBeginImageContext(CGSize(width: imageViewLogo.bounds.width * 3, height: imageViewLogo.bounds.height * 3))
        
        //Transformando a imagem para criar um espaço em volta
        inImage.draw(in: CGRect(x: imageViewLogo.bounds.width * 0.25, y: imageViewLogo.bounds.width * 0.25, width: imageViewLogo.bounds.width * 2.5, height: imageViewLogo.bounds.height * 2.5))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        imageViewLogo.image = newImage
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
    
        _ = textFieldEmail.rx.text.orEmpty.bind(to: viewModel.mail)
        _ = textFieldPassword.rx.text.orEmpty.bind(to: viewModel.password)

        _ = viewModel.isLoading.asObservable().subscribe { (loading) in
            if loading.element ?? false {
                self.showProgressHUD()
            } else {
                self.hideProgressHUD()
            }
        }

        _ = viewModel.shouldEnableConfirm.asObservable().subscribe { (confirmed) in
            let confirm = confirmed.element ?? false
            self.confirmButton.isEnabled = confirm
            if  confirm {
                self.confirmButton.backgroundColor = UIColor.clear
            } else {
                self.confirmButton.backgroundColor = disabledGray
            }
        }
        
        _ = viewModel.logged.asObservable().subscribe { (logged) in
            if logged.element ?? false {
                self.dismiss(animated: true)
            }
        }
        
    }

    var progressHUD : MBProgressHUD?
    func showProgressHUD() {
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.labelText = "Conectando..."
        progressHUD?.mode = .indeterminate
    }

    func hideProgressHUD() {
        progressHUD?.hide(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        
        self.groupView.layer.cornerRadius = 6
        self.groupView.clipsToBounds = true
        hideNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideNavBar()
    }
    
    // MARK: Elementos de Interface
    func hideNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.alpha = 0
    }
    
    func hideKeyboard() {
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
    
    func beginRequisition() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        view.isUserInteractionEnabled = false
        hideKeyboard()
        finishAnimations()
    }
    
    func endRequisition() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        view.isUserInteractionEnabled = true
    }
    
    // MARK: Actions
    @IBAction func login(_ sender: AnyObject) {
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        finishAnimations()
        viewModel.login()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        finishAnimations()
    }
    
    // MARK: - Validação
    func validateFields() -> Bool {
        if(textFieldEmail.text! == "" || textFieldPassword.text! == "") {
            return false
        }
        return true
    }
    
    func createErrorString() -> String {
        
        var errorString = ""
        
        if !validateFields() {
            errorString += "Preencha os campos vazios \n"
        } else if !validateEmail(textFieldEmail.text!) {
            errorString += "Insira um email válido \n"
        }
        
        return errorString
    }
    
    func validateEmail(_ testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
            startAnimations()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            login("" as AnyObject)
        }
        return true
    }
    
    // MARK: Animações
    
    func setupMotionEffect() {
        let motionEffetctH = UIInterpolatingMotionEffect(keyPath: "contentsRect.origin.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        motionEffetctH.minimumRelativeValue = -0.07
        motionEffetctH.maximumRelativeValue = 0.07
        
        let motionEffetctV = UIInterpolatingMotionEffect(keyPath: "contentsRect.origin.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        motionEffetctV.minimumRelativeValue = -0.07
        motionEffetctV.maximumRelativeValue = 0.07
        
        imageViewLogo.addMotionEffect(motionEffetctH)
        imageViewLogo.addMotionEffect(motionEffetctV)

        let motionShadowH = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        motionShadowH.minimumRelativeValue = -10
        motionShadowH.maximumRelativeValue = 10
        
        let motionShadowV = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        motionShadowV.minimumRelativeValue = -10
        motionShadowV.maximumRelativeValue = 10
        
        imageViewLogo.addMotionEffect(motionShadowH)
        imageViewLogo.addMotionEffect(motionShadowV)
        groupView.addMotionEffect(motionShadowH)
        groupView.addMotionEffect(motionShadowV)
    }
    
    func startAnimations() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.imageViewLogo.alpha = 0
            self.layoutConstraintCenterVertical.constant = -(self.view.frame.height/2 - 172)
            self.view.layoutIfNeeded()
        }) 
    }
    
    func finishAnimations() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.imageViewLogo.alpha = 1
            self.layoutConstraintCenterVertical.constant = 6
            self.view.layoutIfNeeded()
        }) 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SignupViewController
        let signupViewModel = SignupViewModel()
        signupViewModel.mail.value = self.textFieldEmail.text ?? ""
        signupViewModel.password.value = self.textFieldPassword.text ?? ""
        controller.viewModel = signupViewModel
    }
}
