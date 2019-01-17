import UIKit


/// Returns a specialised representation for a `<figcaption>` element.
///
class FigcaptionElementConverter: ElementConverter {
    
    let figcaptionFormatter = FigcaptionFormatter()

    // MARK: - ElementConverter

    func convert(
        _ element: ElementNode,
        inheriting attributes: [NSAttributedStringKey: Any],
        contentSerializer serialize: ContentSerializer) -> NSAttributedString {
        
        precondition(element.type == .figcaption)
        
        let attributes = self.attributes(for: element, inheriting: attributes)
        
        return serialize(element, nil, attributes)
    }
    
    private func attributes(for element: ElementNode, inheriting attributes: [NSAttributedStringKey: Any]) -> [NSAttributedStringKey: Any] {
        let elementRepresentation = HTMLElementRepresentation(element)
        let representation = HTMLRepresentation(for: .element(elementRepresentation))
        
        return figcaptionFormatter.apply(to: attributes, andStore: representation)
    }
}

