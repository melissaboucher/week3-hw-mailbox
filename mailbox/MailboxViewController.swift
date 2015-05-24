//
//  MailboxViewController.swift
//  mailbox
//
//  Created by Melissa on 5/19/15.
//  Copyright (c) 2015 Melissa Boucher. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var archiveIconImageView: UIImageView!
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var laterIconImageView: UIImageView!
    @IBOutlet weak var deleteIconImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var composeImageView: UIImageView!
    @IBOutlet weak var composeContainerView: UIView!
    @IBOutlet weak var composeTextField: UITextField!
    @IBOutlet weak var shieldView: UIView!
    
    let blueColor = UIColor(red: 68/255, green: 170/255, blue: 210/255, alpha: 1)
    let yellowColor = UIColor(red: 254/255, green: 202/255, blue: 22/255, alpha: 1)
    let brownColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1)
    let greenColor = UIColor(red: 85/255, green: 213/255, blue: 80/255, alpha: 1)
    let redColor = UIColor(red: 231/255, green: 61/255, blue: 14/255, alpha: 1)
    let grayColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)

    var padding: CGFloat!
    
    var initialMessageCenter: CGPoint!
    var initialLaterIconCenter: CGPoint!
    var initialArchiveIconCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize = CGSize(width:320, height:1432)
        initialMessageCenter = messageImageView.center
        initialLaterIconCenter = laterIconImageView.center
        initialArchiveIconCenter = archiveIconImageView.center
        
        rescheduleImageView.alpha = 0
        listImageView.alpha = 0
        shieldView.alpha = 0
        composeContainerView.alpha = 0

        //top nav has mail icon selected
        segmentedControl.selectedSegmentIndex = 1
        
        //setup scrollviews
        archiveScrollView.frame.origin.x = view.frame.width
        laterScrollView.frame.origin.x = -view.frame.width
        scrollView.frame.origin.x = 0
        
        padding = 30
        
        //edge panning setup
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onLeftEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
//    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
//        if(event.subtype == UIEventSubtype.MotionShake) {
//            var alert = UIAlertController(title: "Shaken",
//                message: "Not Stirred",
//                preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK",
//                style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//    }
    
    
    
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {

        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        //pan began
        if sender.state == UIGestureRecognizerState.Began {
            println("message pan began")
            //hide icons
            archiveIconImageView.alpha = 0
            listIconImageView.alpha = 0
            laterIconImageView.alpha = 0
            deleteIconImageView.alpha = 0
            
            initialMessageCenter = messageImageView.center
            messageContainerView.backgroundColor = grayColor

        }
            
        //panning
        else if sender.state == UIGestureRecognizerState.Changed {
    
            //move message along with the the drag, but only in x direction
            messageImageView.center = CGPoint(x: initialMessageCenter.x + translation.x, y: initialMessageCenter.y)
            
            //begin swipe left
            if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -60 {

                //As the reschedule icon is revealed, it should start semi-transparent and become fully opaque. If released at this point, the message should return to its initial position.
                
                laterIconImageView.alpha = -translation.x/60
                
            }
            
            
            //short swipe left: LATER
            else if messageImageView.frame.origin.x <= -60 && messageImageView.frame.origin.x > -260 {
                
                //After 60 pts, the later icon should start moving with the translation and the background should change to yellow.
                
                messageContainerView.backgroundColor = yellowColor
                listIconImageView.alpha = 0
                laterIconImageView.alpha = 1
                
                laterIconImageView.center = CGPointMake(messageImageView.frame.width + translation.x + CGFloat(padding), messageImageView.center.y)

                
            }
            
                
            //long swipe left: LIST
                
            else if messageImageView.frame.origin.x <= -260 {
                
                messageContainerView.backgroundColor = brownColor
                laterIconImageView.alpha = 0
                listIconImageView.alpha = 1
                listIconImageView.center = CGPointMake(messageImageView.frame.width + translation.x + CGFloat(padding), messageImageView.center.y)

            }

            //begin swipe right
            else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x <= 60 {
                archiveIconImageView.alpha = translation.x/60

            }
            
            
            //short swipe right: ARCHIVE
            else if messageImageView.frame.origin.x > 60 && messageImageView.frame.origin.x < 260 {
                
                messageContainerView.backgroundColor = greenColor
                deleteIconImageView.alpha = 0
                archiveIconImageView.alpha = 1
                
                //use difference
                archiveIconImageView.center = CGPointMake(translation.x - padding, messageImageView.center.y)
                
                
            }
            
            
            //long swipe right: DELETE
            else if messageImageView.frame.origin.x >= 260 {
                
                messageContainerView.backgroundColor = redColor
                archiveIconImageView.alpha = 0
                deleteIconImageView.alpha = 1
                deleteIconImageView.center = CGPointMake(translation.x - padding, messageImageView.center.y)
            }
         
            
            else {
                //initial revealed background color is gray
                messageContainerView.backgroundColor = grayColor
                
                //reset moved icons
                laterIconImageView.center = initialLaterIconCenter
                archiveIconImageView.center = initialArchiveIconCenter
            }
  
        }
            
        //pan ended
        else if sender.state == UIGestureRecognizerState.Ended {
            println("message pan ended")
            
            //stopped at LATER action
            if messageImageView.frame.origin.x < -60 && messageImageView.frame.origin.x > -260 {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = -self.view.frame.width
                    //move later icon out of frame
                    self.laterIconImageView.center.x = self.messageImageView.center.x + self.padding
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            self.rescheduleImageView.alpha = 1
                            }, completion: nil)
                })
                
            }

            //stopped at LIST action
            else if messageImageView.frame.origin.x < -260 {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = -self.view.frame.width
                    //move icon out of frame
                    self.listIconImageView.center.x = self.messageImageView.center.x + self.padding
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            self.listImageView.alpha = 1
                            }, completion: nil)
                })
            }
            
//            //panned to ARCHIVE action
//            else if messageImageView.frame.origin.x > 60 && messageImageView.frame.origin.x < 260 {
//                
//                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
//                    self.messageImageView.frame.origin.x = 2 * self.view.frame.width
//                    //move icon out of frame
//                    self.archiveIconImageView.center.x = self.messageImageView.center.x - self.padding
//                    
//                    }, completion: { (Bool) -> Void in
//                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
//                            //hide whole single message and move other messages up
//                            self.feedImageView.center.y = self.feedImageView.center.y - self.messageImageView.frame.height
//
//                            }, completion: { (Bool) -> Void in
//                                //add message back so you can simulate other actions
//                                self.addMessageToFeed()
//                        })
//                })
//                
//            }
                
                
            //panned to ARCHIVE action
            else if messageImageView.frame.origin.x > 60 && messageImageView.frame.origin.x < 260 {

                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = 2 * self.view.frame.width
                    self.archiveIconImageView.center.x = self.messageImageView.center.x - self.padding
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            //hide whole single message and move other messages up
                            self.archiveMessage(0)

                            }, completion: { (Bool) -> Void in
                        })
                })
                
            }
            
//            //panned to DELETE action
//            else if messageImageView.frame.origin.x > 260 {
//                
//                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
//                    self.messageImageView.frame.origin.x = 2 * self.view.frame.width
//                    //move icon out of frame
//                    self.deleteIconImageView.center.x = self.messageImageView.center.x - self.padding
//                    }, completion: { (Bool) -> Void in
//                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
//                            //hide whole single message and move other messages up
//                            self.feedImageView.center.y = self.feedImageView.center.y - self.messageImageView.frame.height
//                            
//                            }, completion: { (Bool) -> Void in
//                                //add message back so you can simulate other actions
//                                self.addMessageToFeed()
//                        })
//                })
//
//                
//            }
                
                //panned to DELETE action
            else if messageImageView.frame.origin.x > 260 {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = 2 * self.view.frame.width
                    //move icon out of frame
                    self.deleteIconImageView.center.x = self.messageImageView.center.x - self.padding
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            self.deleteMessage(0)
                            
                            }, completion: { (Bool) -> Void in
                        })
                })
                
            }
            
            //didn't pan far enough, bounce animation back
            else {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 12, options: nil, animations: { () -> Void in
                    self.messageImageView.center = self.initialMessageCenter
                }, completion: nil)
            }
        }

    }
    
    //registering simple undo operation
    func archiveMessage(score: NSNumber) {
        undoManager!.registerUndoWithTarget(self, selector:Selector("showMessage:"), object:feedImageView)
        undoManager!.setActionName(NSLocalizedString("archive message", comment: "Archive Message"))
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
            //hide whole single message and move other messages up
            self.feedImageView.center.y = self.feedImageView.center.y - self.messageImageView.frame.height
            
            }, completion: nil)
    }
    
    //registering simple undo operation
    func deleteMessage(score: NSNumber) {
        undoManager!.registerUndoWithTarget(self, selector:Selector("showMessage:"), object:feedImageView)
        undoManager!.setActionName(NSLocalizedString("delete message", comment: "Delete Message"))
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
            //hide whole single message and move other messages up
            self.feedImageView.center.y = self.feedImageView.center.y - self.messageImageView.frame.height
            
            }, completion: nil)
    }
    
    func showMessage(score: NSNumber) {
        undoManager?.registerUndoWithTarget(self, selector: Selector("archiveMessage:"), object:feedImageView)
        undoManager!.setActionName(NSLocalizedString("move to inbox", comment: "Show Message"))

        UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveLinear, animations: { () -> Void in
            self.messageContainerView.alpha = 1
            self.messageImageView.frame.origin.x = 0
            self.messageImageView.alpha = 0
            self.messageContainerView.backgroundColor = self.grayColor
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.feedImageView.center.y += self.messageImageView.frame.height
                    self.messageImageView.alpha = 1
                    }, completion: nil)
        })

    }
    
    func addMessageToFeed() {
        
        UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveLinear, animations: { () -> Void in
            self.messageContainerView.alpha = 1
            self.messageImageView.frame.origin.x = 0
            self.messageImageView.alpha = 0
            self.messageContainerView.backgroundColor = self.grayColor
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.feedImageView.center.y += self.messageImageView.frame.height
                    self.messageImageView.alpha = 1
                    }, completion: nil)
        })
        
    }
    
    func removeMessageFromFeed() {
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
            //hide whole single message and move other messages up
            self.feedImageView.center.y = self.feedImageView.center.y - self.messageImageView.frame.height
        }, completion: nil)
    }
    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {
        
        //show the message again
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.rescheduleImageView.alpha = 0
            self.messageImageView.center.x = self.view.frame.width/2
            self.laterIconImageView.center.x = self.messageImageView.center.x + self.messageImageView.frame.width/2 + self.padding
        })
        
    }
    
    @IBAction func didTapList(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.listImageView.alpha = 0
            self.messageImageView.center.x = self.view.frame.width/2
            self.listIconImageView.center.x = self.messageImageView.center.x + self.messageImageView.frame.width/2 + self.padding
        })
    
    }
    
    
    var edgePanBeganX: CGFloat!
    
    @IBAction func onLeftEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var location = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        println("left edge pan")
        


        hideNonActiveScrollViews()
        
        if sender.state == UIGestureRecognizerState.Began {
            edgePanBeganX = contentView.frame.origin.x
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            contentView.frame.origin.x = edgePanBeganX + translation.x
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            // spring mailbox back into view
            if velocity.x < 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                    }, completion: nil)
                
                // spring forward to show menu
            } else if velocity.x > 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                    self.contentView.frame.origin.x = 280
                    }, completion: nil)
            }
        }
            
            
    }
    
    //expose or hide menu depending on current state
    @IBAction func didPressMenuButton(sender: AnyObject) {
        hideNonActiveScrollViews()

        //menu is currently hidden
        if (contentView.center.x == view.frame.width/2) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentView.frame.origin.x = 280
            })
        }
        //menu is currently exposed
        else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentView.frame.origin.x = 0
            })
        }
    }

    @IBAction func didPressComposeButton(sender: AnyObject) {

        //fade out screen behind
        shieldView.alpha = 0.5
        
        //animate composeImageView to the top
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.composeContainerView.alpha = 1
            self.composeContainerView.frame.origin.y = 18
        })
        self.composeTextField.becomeFirstResponder()
    }
    
    @IBAction func didPressCancelButton(sender: AnyObject) {

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shieldView.alpha = 0
            self.composeContainerView.alpha = 0
            self.composeContainerView.frame.origin.y = self.view.frame.height
            self.composeTextField.endEditing(true)
        })
    }
    
    
    @IBOutlet weak var archiveScrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var laterScrollView: UIScrollView!

    func hideNonActiveScrollViews() {
        if segmentedControl.selectedSegmentIndex == 0 {
                self.scrollView.alpha = 0
                self.laterScrollView.alpha = 1
                self.archiveScrollView.alpha = 0
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
                self.archiveScrollView.alpha = 0
                self.scrollView.alpha = 1
                self.laterScrollView.alpha = 0
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
                self.scrollView.alpha = 0
                self.archiveScrollView.alpha = 1
                self.laterScrollView.alpha = 0
        }
    }
    
    @IBAction func didChangeSegmentedControl(sender: AnyObject) {

        laterScrollView.alpha = 1
        archiveScrollView.alpha = 1
        scrollView.alpha = 1
        
        if segmentedControl.selectedSegmentIndex == 0 {
            segmentedControl.tintColor = yellowColor
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.frame.origin.x = self.view.frame.width
                self.laterScrollView.frame.origin.x = 0
                self.archiveScrollView.frame.origin.x = 2 * self.view.frame.width
            })
            
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            segmentedControl.tintColor = blueColor
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.archiveScrollView.frame.origin.x = self.view.frame.width
                self.scrollView.frame.origin.x = 0
                self.laterScrollView.frame.origin.x = -self.view.frame.width

            })
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
            segmentedControl.tintColor = greenColor
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.frame.origin.x = -self.view.frame.width
                self.archiveScrollView.frame.origin.x = 0
                self.laterScrollView.frame.origin.x = -2 * self.view.frame.width

            })
            
        }
    }
    
    

}
