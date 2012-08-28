/*
	Copyright (c) 2007 Memorphic Ltd. All rights reserved.
	
	Redistribution and use in source and binary forms, with or without 
	modification, are permitted provided that the following conditions 
	are met:
	
		* Redistributions of source code must retain the above copyright 
		notice, this list of conditions and the following disclaimer.
	    	
	    * Redistributions in binary form must reproduce the above 
	    copyright notice, this list of conditions and the following 
	    disclaimer in the documentation and/or other materials provided 
	    with the distribution.
	    	
	    * Neither the name of MEMORPHIC LTD nor the names of its 
	    contributors may be used to endorse or promote products derived 
	    from this software without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
	OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
	LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
	DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
	THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package memorphic.xpath.model
{
	
	/**
	 * A list of predicates, extracted into its own class to avoid duplicating the same
	 * functionality in two places: Step and FilterExpr.
	 */ 
	final public class PredicateList
	{
		
		
		private var predicates:Array;

		
		public function PredicateList(predicates:Array)
		{
			this.predicates = predicates;
			
		}
		
			
		public function filter(nodeList:XMLList, context:XPathContext):XMLList
		{
			var n:int = predicates.length;
			for(var i:int=0; i<n /*&& nodeList.length()>0*/; i++){
				var posPred:SimplePositionPredicate;
				if((posPred = predicates[i] as SimplePositionPredicate)){
					nodeList = posPred.filterXMLList(nodeList, context);
				}else if(predicates[i] is Predicate){
					nodeList = filterByPredicate(nodeList, context, predicates[i] as Predicate);
				}
			}
			return nodeList;
		}
		
		

		private function filterByPredicate(nodeList:XMLList, baseContext:XPathContext, predicate:Predicate):XMLList
		{
			var result:XMLList = new XMLList();
			var node:XML;
			var context:XPathContext = baseContext;
			var contextLength:int = nodeList.length();
			context.contextSize = contextLength;
			for(var i:int=0; i<contextLength; i++){
				node = nodeList[i];
				context.contextNode = node;
				context.contextPosition = i;
				if(predicate.test(context)){
					result += node;
				}
			}
			return result;
		}

	}
}