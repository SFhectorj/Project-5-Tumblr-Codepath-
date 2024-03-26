//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

// Conform to the table view data source protocol (i.e, Declare view controller as UITableViewDataSource and implement required methods)
class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // Create an array property to store the fetched blog posts in the view controller
    var blogPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assign the table view data source to be the view controller
        // Using 'self' it references this file(view controller)
        tableView.dataSource = self
        fetchPosts()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows to display in the table view
        // We can use '.count' to return the number of elements from a collection.
        // In this case we make it return from the blogPosts array variable we made earlier
        return blogPosts.count
    }
    
    // Dequeue, configure and return the custom cell for associated post (i.e., set cell properties for the image view and labels)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Function Declaration: This function is part of the UITableViewDataSource protocol and is called by the table view to get the cell for a specific row in the table view.
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellView", for: indexPath) as! TableViewCell
        // Dequeue Cell: It dequeues a reusable table view cell with the identifier "cellView" from the table view. The dequeueReusableCell(withIdentifier:for:) method dequeues or creates a new cell with the specified reuse identifier.
        
        let blogPost = blogPosts[indexPath.row]
        // Access Blog Post: It accesses the blog post corresponding to the current row index using blogPosts[indexPath.row].
        
        cell.rightLabel.text = blogPost.summary
        // Configure Cell: It configures the dequeued cell (cell) with data from the blog post. Specifically, it sets the text property of the rightLabel in the cell to the summary of the blog post.
        
        if let firstPhoto = blogPost.photos.first {
            Nuke.loadImage(with: firstPhoto.originalSize.url, into: cell.leftImage)
        }
        // Load Image: It checks if the blog post contains any photos. If there is at least one photo (if let firstPhoto = blogPost.photos.first), it loads the image into the leftImage image view of the cell using Nuke. 
        // Nuke is a powerful image loading library for Swift.
        
        return cell
        // Return Cell: Finally, it returns the configured cell to be displayed in the table view.
    }
    
    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("❌ Data is NIL")
                return
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.blogPosts = blog.response.posts
                    self.tableView.reloadData()

                    print("✅ We got \(self.blogPosts.count) posts!")
                    for post in self.blogPosts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }
                
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
