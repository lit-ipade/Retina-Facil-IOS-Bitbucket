//
//  QuizController.swift
//  AppOftamologia
//
//  Created by Jagni Dasa Horta Bezerra on 08/02/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation
import MGSwipeTableCell
import UIKit
import SCLAlertView

var currentQuestionTime = 0

class QuestionController : UITableViewController{
    
    var answered = false
    
    @IBOutlet weak var progressBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var correctCountBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var wrongCountBarButtonItem: UIBarButtonItem!
    
    var selectedIndex : IndexPath?
    var question : Question!
    var keys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        keys = [String](question.options.keys).shuffled
    }

    @IBAction func didTapClose(_ sender: UIBarButtonItem){
        //pauseTimer()
        let appearance = SCLAlertView.SCLAppearance(kDefaultShadowOpacity: 1, showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton(NSLocalizedString("Sim", comment: ""), action: {
            let questionNav = self.navigationController as! QuizNavigationController
            questionNav.quit()
        })
        
        alertView.addButton(NSLocalizedString("Não", comment: ""), action: {
            
        })
        
        alertView.showTitle("Atenção", subTitle: "Deseja realmente sair do teste? Todo progresso será perdido", style: SCLAlertViewStyle.warning, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }

    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == self.tableView {
            return nil
        } else {
            return scrollView.subviews[0]
        }
    }
    
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
            if indexPath.section == 0{
                if indexPath.row == 1 {
                    return 250
                }
            }
            else if(indexPath.section == 2){
                if(indexPath.row == 0){
                    return 200
                }
            }
            return UITableViewAutomaticDimension
        }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if answered{
            return 3
        }
        else{
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return question.image == nil ? 1 : 2
        }
        else{
            if(section == 1){
                
                return keys.count
            
            } else{
            
                return 1
            
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "question")
                cell?.textLabel?.text = question.title
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "image") as! ImageCell
                cell.questionImageView?.image = question.image
                cell.scrollView.delegate = self
                return cell
            }
        }
        else{
            
            if(indexPath.section == 1){
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "answer") as! AnswerCell
                
                cell.contentView.isUserInteractionEnabled = !answered
                
                if answered{
                    
                    if keys[indexPath.row] == question.correctKey{
                        cell.overlayView.alpha = 0.25
                        cell.overlayView.backgroundColor = appMainColor
                    }
                    else{
                        cell.overlayView.alpha = 0.75
                        cell.overlayView.backgroundColor = appWhiteColor
                    }
                }
                
                cell.optionLabel.text = question.options[keys[indexPath.row]]
                cell.itemLabel.text = "\(indexPath.row+1)"
                cell.tag = indexPath.row
                
                //configure right buttons
                
                let confirmButton = MGSwipeButton(title: "Confirmar", backgroundColor: appOrangeColor) {
                    (sender: MGSwipeTableCell!) -> Bool in
                    self.answered = true
                    self.tableView.reloadData();
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.tableView.scrollToRow(at: IndexPath(row: self.keys.count-1, section: 1), at: .top, animated: true)
                        let questionNav = self.navigationController as! QuizNavigationController
                        questionNav.cellComment.isHidden = false
                        
                        let answer = self.keys[cell.tag]
                        
                        if(answer == self.question.correctKey ){
                            questionNav.correctCount += 1
                        }
                        else {
                            questionNav.incorrectCount += 1
                        }
                    }
                    
                    return true
                }
                
                cell.rightButtons = [confirmButton]
                cell.rightSwipeSettings.transition = .rotate3D
                
                if indexPath.row == question.options.count - 1{
                    cell.separator.backgroundColor = appWhiteColor
                }
                
                return cell
                
            }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "comment") as! ComentCell
                if answered{
                    cell.isHidden = false
                }
                else{
                    cell.isHidden = true
                }
                
                cell.comentTextView.text = question.comment
                print("Comentario: \(question.comment)")
                cell.buttonNext.addTarget(self, action: #selector(QuestionController.nextQuestion(_:)), for: .touchUpInside)
                let questionNav = self.navigationController as! QuizNavigationController
                
                questionNav.cellComment = cell
                
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !answered {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.tableView.cellForRow(at: indexPath) as! AnswerCell
        cell.showSwipe(.rightToLeft, animated: true)
        }
    }
        
    @objc func nextQuestion(_ sender: UIButton){
        let questionNav = self.navigationController as! QuizNavigationController
        questionNav.advance()
    }
    
}
