//
//  GameScene.swift
//  Mouse
//
//  Created by Mac on 10.03.16.
//  Copyright (c) 2016 Igor Fuchkin. All rights reserved.
//

import SpriteKit

extension CGPoint {
    func distanceToPoint(point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int = -1
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        if index != -1 {
            self.removeAtIndex(index)
        }
    }
}



class GameScene: SKScene {
    
    var mouseArr = [Mouse]()
    
    var timer : NSTimer?
    
    
    override func didMoveToView(view: SKView) {
        
        #if os(iOS)
            self.size = UIScreen.mainScreen().bounds.size
        #endif
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateWithTimer:", userInfo: nil, repeats: true)
        #if os(iOS)
            self.backgroundColor = UIColor.whiteColor()
        #elseif os(OSX)
            self.backgroundColor = NSColor.whiteColor()
        #endif
        
        addMouse()
    }
    
    deinit{
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func updateWithTimer(timer: NSTimer) {
        if mouseArr.count<100{
        addMouse()
        }
    }
    
    
    func addMouse(){
        let mouse = Mouse()
        self.addChild(mouse)
        mouse.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        mouse.moveMouse()
        mouseArr.append(mouse)
        
        
        mouse.setScale(0)
        
        let scale = CGFloat(arc4random_uniform(5))/10+0.5
        
        mouse.runAction(SKAction.scaleTo(scale, duration: 0.3))
    }
    
    
    override func update(currentTime: CFTimeInterval) {
       
        var mouseForRemove = [Mouse]()
        
        for mouse in mouseArr {
            if mouse.forRemove == true {
            mouseForRemove.append(mouse)
            }
        }
        
        for mouse in mouseForRemove {
            mouseArr.removeObject(mouse)
            mouse.removeFromParent()
        }
        
    }
    #if os(iOS)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touche in touches {
        let location = touche.locationInNode(self)
        let nodes = self.nodesAtPoint(location)
        for node in nodes{
            if node.isKindOfClass(Mouse){
            let mouse = node as! Mouse
            if mouse.isDead == false {
                mouse.dead()
                mouse.isDead = true
            }
            }
        }
        }
        
    }
    #endif
    
    
    #if os(OSX)
    override func mouseDown(theEvent: NSEvent) {
        
        let location = theEvent.locationInNode(self)
        let nodes = self.nodesAtPoint(location)
        for node in nodes{
            if node.isKindOfClass(Mouse){
            let mouse = node as! Mouse
            if mouse.isDead == false {
                mouse.dead()
                mouse.isDead = true
            }
            }
        }
    }
    #endif
    
}
