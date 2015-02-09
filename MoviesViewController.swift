//
//  MoviesViewController.swift
//  freshpotatoes
//
//  Created by Eric Huang on 2/5/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit
//import Reachability

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var movies: [NSDictionary]! = []
    var refreshControl: UIRefreshControl!
    let clientId = "r8kyqsqzcmyj3yvbewnrc7g4"
    let reachability = Reachability.reachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsZero
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        spinner.startAnimating()
        refresh()
    }

    @IBAction func didPan(sender: AnyObject) {
        println("MOVING")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = movies.count
        
        if !reachability.isReachable() {
            count += 1
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movie: NSDictionary!
    
        if reachability.isReachable() {
            movie = movies[indexPath.row]
        } else {
            println(indexPath.row)
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCellWithIdentifier("NetworkErrorCell") as NetworkErrorCell
                return cell
            } else {
                movie = movies[indexPath.row - 1]
            }
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var posterImageURL = movie.valueForKeyPath("posters.detailed") as NSString
        posterImageURL = posterImageURL.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        
        cell.posterImage.setImageWithURL(NSURL(string: posterImageURL))
        cell.title.text = movie["title"] as NSString
        cell.synopsis.text = movie["synopsis"] as NSString
        
        return cell
    }
    
    func refresh() {
        var url: NSURL!
        
        if NSString(string: searchBar.text).length == 0 {
            url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=\(clientId)")
        } else {
            url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=\(clientId)&q=\(searchBar.text)&page_limit=10")!
        }
        
        var request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            // Disable spinners
            self.refreshControl?.endRefreshing()
            self.spinner.stopAnimating()

            if (error? == nil) {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = responseDictionary["movies"] as? [NSDictionary]
            }
            
            self.tableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        refresh()
        view.endEditing(true)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as MovieDetailViewController
        var cell = sender as MovieCell
        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
        
        println(cell.posterImage.image?.size)
        vc.movie = movies[indexPath!.row]
        vc.posterImage = cell.posterImage
        
        searchBar.endEditing(true)
    }
}
