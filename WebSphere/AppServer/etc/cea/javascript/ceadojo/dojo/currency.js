/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["dojo.currency"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["dojo.currency"] = true;
dojo.provide("dojo.currency");

dojo.require("dojo.number");
dojo.require("dojo.i18n");
dojo.requireLocalization("dojo.cldr", "currency", null, "ROOT,af,ak,am,ar,asa,az,be,bez,bg,bm,bn,bo,br,ca,cgg,chr,cs,cy,da,dav,de,ebu,ee,el,el-polyton,en,en-au,en-bz,en-ca,en-hk,en-jm,en-mt,en-na,en-nz,en-sg,en-tt,es,es-ec,es-pr,es-us,et,fa,fa-af,ff,fi,fil,fr,fr-ca,ga,gl,gsw,guz,ha,he,hi,hr,hu,is,it,iw,ja,jmc,ka,kab,kam,kde,kea,khq,ki,kln,ko,ksb,lag,lg,lt,luo,luy,lv,mas,mer,mfe,mg,mk,ml,mo,mt,naq,nb,nd,ne,nl,nn,no,nyn,om,pa-arab,pa-pk,pl,pt,rm,ro,rof,ru,rwk,saq,seh,ses,sg,sh,shi,shi-tfng,sk,sl,sn,so,sq,sr,sr-latn,sv,sw,te,teo,th,ti,tl,tr,tzm,uk,ur,vi,vun,xog,yo,zh,zh-hans-hk,zh-hant,zh-hant-hk,zh-hk,zh-mo,zh-tw");
dojo.require("dojo.cldr.monetary");

/*=====
dojo.currency = {
	// summary: localized formatting and parsing routines for currencies
	//
	// description: extends dojo.number to provide culturally-appropriate formatting of values
	//	in various world currencies, including use of a currency symbol.  The currencies are specified
	//	by a three-letter international symbol in all uppercase, and support for the currencies is
	//	provided by the data in `dojo.cldr`.  The scripts generating dojo.cldr specify which
	//	currency support is included.  A fixed number of decimal places is determined based
	//	on the currency type and is not determined by the 'pattern' argument.  The fractional
	//	portion is optional, by default, and variable length decimals are not supported.
}
=====*/

dojo.currency._mixInDefaults = function(options){
	options = options || {};
	options.type = "currency";

	// Get locale-dependent currency data, like the symbol
	var bundle = dojo.i18n.getLocalization("dojo.cldr", "currency", options.locale) || {};

	// Mixin locale-independent currency data, like # of places
	var iso = options.currency;
	var data = dojo.cldr.monetary.getData(iso);

	dojo.forEach(["displayName","symbol","group","decimal"], function(prop){
		data[prop] = bundle[iso+"_"+prop];
	});

	data.fractional = [true, false];

	// Mixin with provided options
	return dojo.mixin(data, options);
}

/*=====
dojo.declare("dojo.currency.__FormatOptions", [dojo.number.__FormatOptions], {
	//	type: String?
	//		Should not be set.  Value is assumed to be "currency".
	//	symbol: String?
	//		localized currency symbol. The default will be looked up in table of supported currencies in `dojo.cldr`
	//		A [ISO4217](http://en.wikipedia.org/wiki/ISO_4217) currency code will be used if not found.
	//	currency: String?
	//		an [ISO4217](http://en.wikipedia.org/wiki/ISO_4217) currency code, a three letter sequence like "USD".
	//		For use with dojo.currency only.
	//	places: Number?
	//		number of decimal places to show.  Default is defined based on which currency is used.
	type: "",
	symbol: "",
	currency: "",
	places: ""
});
=====*/

dojo.currency.format = function(/*Number*/value, /*dojo.currency.__FormatOptions?*/options){
// summary:
//		Format a Number as a currency, using locale-specific settings
//
// description:
//		Create a string from a Number using a known, localized pattern.
//		[Formatting patterns](http://www.unicode.org/reports/tr35/#Number_Elements)
//		appropriate to the locale are chosen from the [CLDR](http://unicode.org/cldr)
//		as well as the appropriate symbols and delimiters and number of decimal places.
//
// value:
//		the number to be formatted.

	return dojo.number.format(value, dojo.currency._mixInDefaults(options));
}

dojo.currency.regexp = function(/*dojo.number.__RegexpOptions?*/options){
//
// summary:
//		Builds the regular needed to parse a currency value
//
// description:
//		Returns regular expression with positive and negative match, group and decimal separators
//		Note: the options.places default, the number of decimal places to accept, is defined by the currency type.
	return dojo.number.regexp(dojo.currency._mixInDefaults(options)); // String
}

/*=====
dojo.declare("dojo.currency.__ParseOptions", [dojo.number.__ParseOptions], {
	//	type: String?
	//		Should not be set.  Value is assumed to be currency.
	//	currency: String?
	//		an [ISO4217](http://en.wikipedia.org/wiki/ISO_4217) currency code, a three letter sequence like "USD".
	//		For use with dojo.currency only.
	//	symbol: String?
	//		localized currency symbol. The default will be looked up in table of supported currencies in `dojo.cldr`
	//		A [ISO4217](http://en.wikipedia.org/wiki/ISO_4217) currency code will be used if not found.
	//	places: Number?
	//		fixed number of decimal places to accept.  The default is determined based on which currency is used.
	//	fractional: Boolean?|Array?
	//		Whether to include the fractional portion, where the number of decimal places are implied by the currency
	//		or explicit 'places' parameter.  The value [true,false] makes the fractional portion optional.
	//		By default for currencies, it the fractional portion is optional.
	type: "",
	currency: "",
	symbol: "",
	places: "",
	fractional: ""
});
=====*/

dojo.currency.parse = function(/*String*/expression, /*dojo.currency.__ParseOptions?*/options){
	//
	// summary:
	//		Convert a properly formatted currency string to a primitive Number,
	//		using locale-specific settings.
	//
	// description:
	//		Create a Number from a string using a known, localized pattern.
	//		[Formatting patterns](http://www.unicode.org/reports/tr35/#Number_Format_Patterns)
	//		are chosen appropriate to the locale, as well as the appropriate symbols and delimiters
	//		and number of decimal places.
	//
	// expression: A string representation of a currency value

	return dojo.number.parse(expression, dojo.currency._mixInDefaults(options));
}

}
