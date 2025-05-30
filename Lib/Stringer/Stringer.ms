/** Stringer
  *
  * RegEx: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-52C211F5-CD4E-4F4C-9C31-08A0611BBEEF
 */
struct Stringer_v
(
	/* construct */
	_string,
	ignore_case = true,

	/* properties */
	RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" ),
	IgnoreCase	= ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase,


	/** Remove suffix last part of string
	  *
	  * @param string delimiters	of suffix
	  * @param string pattern	only suffix matching this wil be removed
	  *
	  *
	  * E.G.:
	  * 		"foo-bar_01"	>>> "foo-bar"
	  * 		"foo-bar-x"	>>> "foo-bar"
	  */
	function removeSuffix delimiters:"_-" pattern:".*" =
	(
		format "\n"; print "Stringer_v.removeSuffix()"

		if (split = filterString this._string delimiters).count > 1 then
			stripped_string = this.replaceInString (this._string) ( "["+delimiters+ "]"+ split[split.count] + "$") ""


		/* TEST IF SUFFIX MATCH PATTERN  */
		if stripped_string != undefined and this.isMatch (stripped_string) (pattern) then
			_string = stripped_string

		format "_STRING:	% \n" _string
		_string --return
	),

	--private
	/** Is match
	  *
	  */
	function isMatch pattern =
	(
		--format "\n"; print "Stringer_v.isMatch()"
		RegEx.IsMatch _string pattern
	),


	/** Get match
	  *
	  */
	function getMatches pattern =
	(
		--format "\n"; print "Stringer_v.getMatch()"

		matches = if this.ignore_case then
					RegEx.matches _string pattern ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

				else
					RegEx.matches _string pattern

		(for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value ))

	),

	/** Replace
	  *
	  */
	function replaceInString pattern replace_string  =
	(
		--format "\n"; print "Stringer_v.replace()"
		(this._getReplace pattern ).Replace _string replace_string
	),

	/** Get replace
	  *
	  */
	function _getReplace pattern =
	(
		--format "\n"; print "Stringer_v._getReplace()"
		if this.ignore_case then
				( dotNetObject "System.Text.RegularExpressions.Regex" pattern IgnoreCase  )
			else

				( dotNetObject "System.Text.RegularExpressions.Regex" pattern  )
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "Stringer.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
