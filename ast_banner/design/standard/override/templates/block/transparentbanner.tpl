{def $valid_nodes = $block.valid_nodes}

{ezscript_require( 'jquery-1.6.min.js' )}
{ezcss_require( 'style.css' )}
{literal}
<script type="text/javascript">
$(function(){
	banniereCookie.init();
});

var banniereCookie = function(){
	
	var hasFlash, flashVersion;
	
	function _init() {
		if (testIfCookie()) {
			return;
		}else{
			getFlashPluginInfos();
			if (hasFlash && flashVersion[0] > 8) {
				insertFlash();
			} else {
				insertAlternative();
			}
			hideSelect();
			insertCloseButton();
		}
	}
	
	function testIfCookie(){
		if ($.cookie('CookieBanniere{/literal}{$block.id}{literal}') == 'true') {
			return true;
		}
		return false;
	}
	
	function putCookie() {
		$.cookie('CookieBanniere{/literal}{$block.id}{literal}', 'true', {expires: 7});
	}
	
	function getFlashPluginInfos() {
		// thanks to Stephen Belanger http://jquery-flash.stephenbelanger.com/ - MIT/GPL.
		var p = navigator.plugins;
        if (p && p.length) {
            var f = p['Shockwave Flash'];
            if (f) {
                has = true;
                if (f.description) cv = f.description.replace(/([a-zA-Z]|\s)+/, "").replace(/(\s+r|\s+b[0-9]+)/, ".").split(".");
            }
            if (p['Shockwave Flash 2.0']) {
                has = true;
                cv = '2.0.0.11';
            }
        } else {
            try {
                var axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");
            } catch(e) {
                try {
                    var axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");
                    cv = [6, 0, 21];
                    has = true;
                } catch(e) {};
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
                } catch(e) {};
            }
            if (axo != null) {
                cv = axo.GetVariable("$version").split(" ")[1].split(",");
                has = true;
                ie = true;
            }
        }
		hasFlash = has;
		flashVersion = cv;
	}
	
	function insertFlash() {
		$('body').append('<a id="banniereCloseButton2" href="#" role="button"><div id="banniere"><div id="banniereBackground"><div id="banniereContent"><p>{/literal}<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="{$valid_nodes[0].data_map.file.content.width}" height="{$valid_nodes[0].data_map.file.content.height}" id="banniere" align="middle" ><param name="allowScriptAccess" value="sameDomain" /><param name="allowFullScreen" value="false" /><param name="movie" value={concat("content/download/",$valid_nodes[0].data_map.file.contentobject_id,"/",$valid_nodes[0].data_map.file.content.contentobject_attribute_id,"/",$valid_nodes[0].data_map.file.content.original_filename)|ezurl} /><param name="quality" value="high" /><param name="wmode" value="transparent" /><param name="bgcolor" value="#ffffff" /><embed src={concat("content/download/",$valid_nodes[0].data_map.file.contentobject_id,"/",$valid_nodes[0].data_map.file.content.contentobject_attribute_id,"/",$valid_nodes[0].data_map.file.content.original_filename)|ezurl} quality="high" wmode="transparent" bgcolor="#ffffff" {if $valid_nodes[0].data_map.file.content.width|gt( 0 )}width="{$valid_nodes[0].data_map.file.content.width}"{/if}{if $valid_nodes[0].data_map.file.content.height|gt( 0 )}height="{$valid_nodes[0].data_map.file.content.height}"{/if} name="banniere" align="middle" allowScriptAccess="sameDomain" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /></object>{literal}</p></div></div></div></a>');
		$('#banniereCloseButton2').click(function(e) {
			close('abort');
		});
	};
	
	function insertAlternative() {
		$('body').append('<div id="banniere"><div id="banniereBackground"><div id="banniereContent"><p>Here comes the alternative picture (without dimensions !!!)</p></div></div></div>');
	};
	
	function insertCloseButton(){
		$('#banniereContent').prepend('<a id="banniereCloseButton" href="#" role="button">Close X</a>');
		$('#banniereCloseButton').click(function(e) {
			close('abort');
		});
	}
	
	function close(reason) {
		putCookie();
		$('#banniere').remove();
		showSelects();
		/*
		
		Ici le code du tracker.
		
		*/			
		
	}
	
	function hideSelect(){
		$('select').css('visibility', 'hidden');
	}
	
	function showSelects(){
		$('select').css('visibility', 'visible');
	}
	
	return {init:_init, close:close}
}();

/**
 * Cookie plugin
 *
 * Copyright (c) 2006 Klaus Hartl (stilbuero.de)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */

/**
 * Create a cookie with the given name and value and other optional parameters.
 *
 * @example $.cookie('the_cookie', 'the_value');
 * @desc Set the value of a cookie.
 * @example $.cookie('the_cookie', 'the_value', { expires: 7, path: '/', domain: 'jquery.com', secure: true });
 * @desc Create a cookie with all available options.
 * @example $.cookie('the_cookie', 'the_value');
 * @desc Create a session cookie.
 * @example $.cookie('the_cookie', null);
 * @desc Delete a cookie by passing null as value. Keep in mind that you have to use the same path and domain
 *	   used when the cookie was set.
 *
 * @param String name The name of the cookie.
 * @param String value The value of the cookie.
 * @param Object options An object literal containing key/value pairs to provide optional cookie attributes.
 * @option Number|Date expires Either an integer specifying the expiration date from now on in days or a Date object.
 *							 If a negative value is specified (e.g. a date in the past), the cookie will be deleted.
 *							 If set to null or omitted, the cookie will be a session cookie and will not be retained
 *							 when the the browser exits.
 * @option String path The value of the path atribute of the cookie (default: path of page that created the cookie).
 * @option String domain The value of the domain attribute of the cookie (default: domain of page that created the cookie).
 * @option Boolean secure If true, the secure attribute of the cookie will be set and the cookie transmission will
 *						require a secure protocol (like HTTPS).
 * @type undefined
 *
 * @name $.cookie
 * @cat Plugins/Cookie
 * @author Klaus Hartl/klaus.hartl@stilbuero.de
 */
 
jQuery.cookie = function(name, value, options) {
	if (typeof value != 'undefined') { // name and value given, set cookie
		options = options || {};
		if (value === null) {
			value = '';
			options.expires = -1;
		}
		var expires = '';
		if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
			var date;
			if (typeof options.expires == 'number') {
				date = new Date();
				date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
			} else {
				date = options.expires;
			}
			expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
		}
		// CAUTION: Needed to parenthesize options.path and options.domain
		// in the following expressions, otherwise they evaluate to undefined
		// in the packed version for some reason...
		var path = options.path ? '; path=' + (options.path) : '';
		var domain = options.domain ? '; domain=' + (options.domain) : '';
		var secure = options.secure ? '; secure' : '';
		document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
	} else { // only name given, get cookie
		var cookieValue = null;
		if (document.cookie && document.cookie != '') {
			var cookies = document.cookie.split(';');
			for (var i = 0; i < cookies.length; i++) {
				var cookie = jQuery.trim(cookies[i]);
				// Does this cookie string begin with the name we want?
				if (cookie.substring(0, name.length + 1) == (name + '=')) {
					cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
					break;
				}
			}
		}
		return cookieValue;
	}
};
</script>
{/literal}