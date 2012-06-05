package idv.cjcat.rusher.utils
{
	import flash.errors.IllegalOperationError;
	
	public function construct(classObj:Class, params:Array = null):* {
		
		if (!params) return new classObj();
		
		switch (params.length) {
			case 0:
				return new classObj();
				break;
				
			case 1:
				return new classObj(params[0]);
				break;
				
			case 2:
				return new classObj(params[0], params[1]);
				break;
				
			case 3:
				return new classObj(params[0], params[1], params[2]);
				break;
				
			case 4:
				return new classObj(params[0], params[1], params[2], params[3]);
				break;
				
			case 5:
				return new classObj(params[0], params[1], params[2], params[3], params[4]);
				break;
				
			case 6:
				return new classObj(params[0], params[1], params[2], params[3], params[4], params[5]);
				break;
				
			case 7:
				return new classObj(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
				break;
				
			case 8:
				return new classObj(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
				break;
				
			case 9:
				return new classObj(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
				break;
				
			case 10:
				return new classObj(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]);
				break;
				
			default:
				throw new IllegalOperationError("The number of parameters given exceeds the maximum number this method can handle.");
				break;
		}
	}
}