package smartWork.util
{
	import mx.utils.StringUtil;
	
	/**
	 * 자바의 StringTokenzer랑 똑같습니다.
	 * Create By jjaeko
	 */
	public class StringTokenizer
	{
		private var string : String;
		private var skipCount : int;
		private var tokens : Array;
		
		
		/**
		 * 지정된 캐릭터 라인에 대한 StringTokenizer 를 작성합니다.
		 * 단, delimiter를 지정하지 않을 경우 디폴트 단락문자("\t\n\r\f")를 사용합니다.
		 */
		public function StringTokenizer(string : String, delimiter : String = null) 
		{
			this.string = string;
			
			if(string == null || string.length == 0)
			{
				tokens = new Array();
				return;
			}
			
			if(delimiter == null)
			{
				this.tokens = defaultTokens(string);
			} else
			{
				this.tokens = string.split(delimiter);		
			}
		}
		
		/**
		 * 디폴트 단락문자로 토큰을 구성합니다.
		 */
		private function defaultTokens(string : String) : Array
		{
			var tmpStr : String = StringUtil.trim(string);
			var tmpArr : Array = new Array();
			var startPosition : int = 0;
			var endPosition : int;
			
			if(tmpStr.length == 0)
				return new Array();
			
			while(1) 
			{
				var flag : Boolean = false;
				for(var i:int = startPosition; i < tmpStr.length; i++)
				{
					if(flag)
					{
						if(!StringUtil.isWhitespace(tmpStr.charAt(i)))
						{
							endPosition = i;
							break;
						}
					}
					
					//whiteSpace가 맞을경우 flag를 true로 시켜주고
					//바로 위에 코드에서 endPos를 설정한다.
					if(StringUtil.isWhitespace(tmpStr.charAt(i)))
						flag = true;
					
					//여기서 endPos를 세팅해줘야 마지막 토큰을 만들어낼 수 있다.
					if(i == tmpStr.length - 1)
						endPosition = tmpStr.length;
				}
				
				var token : String = StringUtil.trim(tmpStr.substring(startPosition, endPosition));
				
				if(token != "")
				{
					tmpArr.push(StringUtil.trim(token));
					startPosition = endPosition;
				}
				
				if(endPosition == tmpStr.length)
					break;
			}
			
			return tmpArr;
		}
		
		/**
		 * 토큰나이저로 부터 다음의 토큰을 돌려줍니다. 
		 * 단, 다음 토큰이 없다면 null
		 */
		public function nextToken() : String 
		{
			if(hasMoreTokens())
			{
				return getToken(skipCount++);
			} else 
			{
				return null;
			}
		}
		
		/**
		 * 토큰나이저의 캐릭터 라인으로 이용할 수 있는 토큰이 아직 있을지 어떨지를 판정합니다. 
		 */ 
		public function hasMoreTokens() : Boolean 
		{
			if(skipCount < tokens.length)
			{
				return true;
			} else
			{
				return false;
			}
		}
		
		/**
		 * 총 토큰 수를 구합니다.
		 */ 
		public function getTokenTotalCount() : int
		{
			return tokens.length;
		}
		
		/**
		 * 현재 남아 있는 토큰 수를 구합니다.
		 */
		public function get getTokenCount() : int
		{
			return tokens.length - skipCount;
		}
		
		/**
		 * 가장 첫번째 토큰을 돌려 줍니다.
		 * 단, 토큰이 없을 경우 null을 리턴 합니다.
		 */ 
		public function firstToken() : String
		{
			if(tokens.length == 0)
				return null;
				
			return getToken(0);
		}
		
		/**
		 * 가장 마지막 토큰을 돌려 줍니다.
		 * 단, 토큰이 없을 경우 null을 리턴 합니다.
		 */ 
		public function lastToken() : String
		{
			if(tokens.length == 0)
				return null;
				
			return getToken(tokens.length - 1);
		}
		
		/**
		 * index 위치의 토큰을 돌려 줍니다.
		 */
		public function getToken(index : int) : String
		{
			if(tokens.length-1 < index)
				return null;
			
			return tokens[index];
		}
		
		/**
		 * 토큰나이저의 토큰배열을 돌려 줍니다.
		 */ 
		public function getTokens() : Array
		{
			return tokens;
		}
		
		/**
		 * 토큰나이저의 토큰에서 지정된 토큰의 갯수를 검색합니다.
		 * 대소문자를 구별하지 않습니다.
		 */ 
		public function scanTokenCount(token : String) : int
		{
			var arr : Array = getTokens();
			var count : int = 0;
				
			for(var i:int = 0; i < arr.length; i++)
			{
				if(String(arr[i]).toUpperCase() == token.toUpperCase()) 
					count++;
			}
			
			return count;
		}
		
		/**
		 * 토큰나이저의 토큰에서 지정된 토큰의 인덱스를 구합니다.
		 * 대소문자를 비교하지 않으며 존재하지 않을경우 -1이 돌려집니다.
		 */ 
		public function getTokenIndex(token : String) : int
		{
			var arr : Array = getTokens();
			for(var i:int = 0; i < arr.length; i++)
			{
				if(String(arr[i]).toUpperCase() == token.toUpperCase()) 
					return i;
			}
			
			return -1;
		}
		
		/**
		 * 토큰나이저의 캐릭터 라인을 돌려 줍니다. 
		 */
		public function toString() : String 
		{
			return string;
		}		
	}
}