import UIKit
import InstantSearchCore
import InstantSearch

class ViewController: UIViewController, HitTableViewDataSource {
    
    var instantSearchBinder: InstantSearchBinder!
    @IBOutlet weak var hitsTable: HitsTableWidget!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsTable.hitDataSource = self
        instantSearchBinder = AlgoliaSearchManager.instance.instantSearchBinder
        instantSearchBinder.addAllWidgets(in: self.view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = hitsTable.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        
        cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.textLabel?.highlightedTextColor = .black
        cell.textLabel?.highlightedBackgroundColor = .yellow
        
        cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let facetController = segue.destination as? FacetController {
            facetController.instantSearchBinder = instantSearchBinder
        }
        
        if let collectionViewController = segue.destination as? CollectionViewController {
            collectionViewController.instantSearchBinder = instantSearchBinder
        }
    }
}
