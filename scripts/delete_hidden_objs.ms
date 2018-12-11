-- Very simple script to remove all hidden geometry in the scene

 for obj in Geometry do
 (
	 if obj.isHidden then(
		 delete obj
	 )
 )
 
