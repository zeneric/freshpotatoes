//
//  MovieDetailViewController.swift
//  freshpotatoes
//
//  Created by Eric Huang on 2/8/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var movie: NSDictionary!
    var posterImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        navigationItem.title = movie["title"] as? String
        navigationController?.title = movie["title"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("MoviePosterCell") as MoviePosterCell
            cell.posterImage.image = self.posterImage.image

            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("MovieDescriptionCell") as MovieDescriptionCell
            cell.synopsis.text = movie["synopsis"] as NSString
            
            return cell
        }
    }
}
