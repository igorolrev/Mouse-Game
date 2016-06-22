//
//  Mouse.swift
//  Mouse
//
//  Created by Mac on 10.03.16.
//  Copyright (c) 2016 Igor Fuchkin. All rights reserved.
//

import SpriteKit


class Mouse_resource {
    let mouse_texture:SKTexture!
    var animations = [SKTexture]()
    class var sharedInstance : Mouse_resource {
        struct Static {
            static let instance : Mouse_resource = Mouse_resource()
        }
        return Static.instance
    }
    init() {
        mouse_texture = SKTexture(imageNamed: "Mouse")
        for i in 0...7{
            let texture = SKTexture(imageNamed: "blood_\(i)")
            animations.append(texture)
        }
    }
}






class Mouse:SKSpriteNode {
    
    var isDead = false
    var forRemove = false
    
    init(){

        let texture = Mouse_resource.sharedInstance.mouse_texture
        #if os(iOS) || os(tvOS)
            let color = UIColor.clearColor()
        #else
            let color = NSColor.clearColor()
        #endif
        super.init(texture: texture, color: color, size: texture.size())
        
        
        let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
        
        self.color = colors[randomIndex]
        self.colorBlendFactor = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func moveMouse(){
    
        
        #if os(iOS)
            let screenSize = UIScreen.mainScreen().bounds.size
        #elseif os(OSX)
            let screenSize = NSScreen.mainScreen()!.frame.size
        #endif
        
        let x = arc4random_uniform(UInt32(screenSize.width+100))
        let y = arc4random_uniform(UInt32(screenSize.height+100))
        
        let newMousePosition = CGPoint(x: CGFloat(x)-50, y: CGFloat(y)-50)
        
        let speed:CGFloat = CGFloat(arc4random_uniform(4)) + 3
        
        
        let minPoint = CGPoint.zero
        let maxPoint = CGPoint(x: screenSize.width, y: screenSize.height)
        let maxdistance:CGFloat = minPoint.distanceToPoint(maxPoint)
        
        
        let distance = newMousePosition.distanceToPoint(self.position)
        let duration:CGFloat = distance * speed / maxdistance
        
        
        /*Поворот в сторону движения*/
        let tNAnchPoinXDiff: CGFloat = newMousePosition.x - self.position.x
        let tNAnchPoinYDiff: CGFloat = newMousePosition.y - self.position.y
        let angularVelocity = -atan2f(Float(tNAnchPoinXDiff), Float(tNAnchPoinYDiff))
        
        
        
        let act_move = SKAction.moveTo(newMousePosition, duration: Double(duration))
        act_move.timingMode = SKActionTimingMode.EaseOut
        
        
        let act_rotate = SKAction.rotateToAngle(CGFloat(angularVelocity), duration: 0.2, shortestUnitArc: true)
        
        self.removeAllActions()
        
        self.runAction(SKAction.group([act_move,act_rotate]), completion: { () -> Void in
            self.moveMouse()
        })
    }
    
    
    func dead(){
        self.removeAllActions()
        self.colorBlendFactor = 0
        self.runAction(SKAction.animateWithTextures(Mouse_resource.sharedInstance.animations, timePerFrame: 0.05, resize: true, restore: false)) { () -> Void in
            self.forRemove = true
        }
    }
    
    
    
}