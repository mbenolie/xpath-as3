package memorphic.xpath.model
{
	import memorphic.utils.XMLUtil;
	
	
	/**
	 * [From the spec]
	 * 
	 * 2.2 Axes
	 * 
	 * The following axes are available:
	 * 
	 * 	- the child axis contains the children of the context node
	 *  - the descendant axis contains the descendants of the context node; a descendant is a child 
	 * 		or a child of a child and so on; thus the descendant axis never contains attribute or 
	 * 		namespace nodes
	 *  - the parent axis contains the parent of the context node, if there is one
	 *  - the ancestor axis contains the ancestors of the context node; the ancestors of the context 
	 * 		node consist of the parent of context node and the parent's parent and so on; thus, the 
	 * 		ancestor axis will always include the root node, unless the context node is the root node
	 *  - the following-sibling axis contains all the following siblings of the context node; if the 
	 * 		context node is an attribute node or namespace node, the following-sibling axis is empty
	 *  - the preceding-sibling axis contains all the preceding siblings of the context node; if the 
	 * 		context node is an attribute node or namespace node, the preceding-sibling axis is empty
	 *  - the following axis contains all nodes in the same document as the context node that are 
	 * 		after the context node in document order, excluding any descendants and excluding 
	 * 		attribute nodes and namespace nodes
	 *  - the preceding axis contains all nodes in the same document as the context node that are 
	 * 		before the context node in document order, excluding any ancestors and excluding attribute 
	 * 		nodes and namespace nodes
	 *  - the attribute axis contains the attributes of the context node; the axis will be empty 
	 * 		unless the context node is an element
	 *  - the namespace axis contains the namespace nodes of the context node; the axis will be empty 
	 * 		unless the context node is an element
	 *  - the self axis contains just the context node itself
	 *  - the descendant-or-self axis contains the context node and the descendants of the context node
	 *  - the ancestor-or-self axis contains the context node and the ancestors of the context node; 
	 * 		thus, the ancestor axis will always include the root node
	 * 
	 * NOTE: The ancestor, descendant, following, preceding and self axes partition a document (ignoring 
	 * attribute and namespace nodes): they do not overlap and together they contain all the nodes in 
	 * the document.
	 * 
	 * 
	 * Axes
	 * 
	 * 		[6] AxisName ::=
	 * 					'ancestor'	
	 * 					| 'ancestor-or-self'	
	 * 					| 'attribute'	
	 * 					| 'child'	
	 * 					| 'descendant'	
	 * 					| 'descendant-or-self'	
	 * 					| 'following'	
	 * 					| 'following-sibling'	
	 * 					| 'namespace'	
	 * 					| 'parent'	
	 * 					| 'preceding'	
	 * 					| 'preceding-sibling'	
	 * 					| 'self'
	 * 
	 * 
	 */
	public class Axis
	{
		
		
		public var axisSpecifier:String;
		
		
		
		public function Axis(axisSpecifier:String)
		{
			this.axisSpecifier = axisSpecifier;
		}
		
		
		
		/**
		 * 
		 */ 		
		public function selectAxis(context:XPathContext):XMLList
		{
			var node:XML = context.contextNode;
			switch(axisSpecifier){
				
			case AxisNames.ANCESTOR:
				return selectAncestor(node);
				
			case AxisNames.ANCESTOR_OR_SELF:
				return node + selectAncestor(node);
				
			case AxisNames.ATTRIBUTE:
				return node.attributes();
				
			case AxisNames.CHILD:
				return node.children();
				
			case AxisNames.DESCENDANT:
				return node.descendants();
				
			case AxisNames.DESCENDANT_OR_SELF:
				return node + node.descendants();
				
			case AxisNames.FOLLOWING:
				return selectFollowingSibling(node);
				
			case AxisNames.FOLLOWING_SIBLING:
				return selectFollowingSibling(node);
				
			case AxisNames.NAMESPACE:
				return node.namespaceDeclarations();
				
			case AxisNames.PARENT:
				return <></> + node.parent();
				
			case AxisNames.PRECEDING:
				return selectPreceding(node);
				
			case AxisNames.PRECEDING_SIBLING:
				return selectPrecedingSibling(node);
				
			case AxisNames.SELF:
				return <></> + node;
			}
			
			throw new Error("Invalid Axis name");
		}
		

		
		private function selectAncestor(node:XML):XMLList
		{
			var ancestors:XMLList = new XMLList();
			var p:XML = node.parent();
			while(p){
				ancestors += p;
				p = p.parent();
			}
			return ancestors;
		}
		

		private function selectFollowingSibling(node:XML):XMLList
		{
			var following:XMLList = new XMLList();
			var i:int = node.childIndex();
			var allSiblings:XMLList = node.parent().children();
			var n:int = allSiblings.length();
			for(; i<n; i++){
				following += allSiblings[i];
			}
			return following;
		}
		
		private function selectPrecedingSibling(node:XML):XMLList
		{
			var preceding:XMLList = new XMLList();
			var i:int = node.childIndex();
			var allSiblings:XMLList = node.parent().children();
			while(i--){
				preceding += allSiblings[i];
			}
			return preceding;
		}
		

		private function selectFollowing(node:XML):XMLList
		{
			var following:XMLList = new XMLList();
			var root:XML = XMLUtil.rootNode(node)
			var allNodes:XMLList = root + root.descendants();
			var eachNode:XML;
			var foundNode:Boolean = false;
			
			for each(eachNode in allNodes){
				if(foundNode){
					following += eachNode;
				}else if(eachNode == node){
					foundNode = true;
				}
			}
			return following;
		}
		
		
		private function selectPreceding(node:XML):XMLList
		{
			var preceding:XMLList = new XMLList();
			var root:XML = XMLUtil.rootNode(node);
			var allNodes:XMLList = root + root.descendants();
			var eachNode:XML;
			
			for each(eachNode in allNodes){
				if(eachNode == node){
					break;
				}else{
					// N.B Axis must be built backwards to maintain proper position order
					preceding = node + preceding;
				}
			}
			
			return preceding;
		}
		
	}
}