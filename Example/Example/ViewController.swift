import UIKit
import InstantSearchCore
import InstantSearch

class ViewController: UIViewController, HitDataSource {
    
    var instantSearchBinder: InstantSearchBinder!
    @IBOutlet weak var hitsTable: HitsTableWidget!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsTable.hitDataSource = self
        instantSearchBinder = InstantSearchBinder(searcher: AlgoliaSearchManager.instance.searcher, view: self.view)
    }
    
    func cellFor(hit: [String : Any], at indexPath: IndexPath) -> UITableViewCell {
        let cell = hitsTable.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        
        cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.textLabel?.highlightedTextColor = .black
        cell.textLabel?.highlightedBackgroundColor = .yellow
        
        cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let facetController = segue.destination as! FacetController
        facetController.instantSearchBinder = instantSearchBinder
    }
}
