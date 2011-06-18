<?php
/**
 * Changes currently logged-in user, without checking the password (but still checks that user is enabled)
 * Please make sure that it is only accessible to restricted user groups
 *
 * @author G. Giunta
 * @version $Id$
 *
 * @todo fix this module and its templates for i18n
 */

$Result = array();
$module = $Params['Module'];

$ini = eZINI::instance();
$memberId = count( $module->ViewParameters ) ? (int)$module->ViewParameters[0] : false;
if ( $memberId && $memberId != $ini->variable( 'UserSettings', 'AnonymousUserID' ) )
{
    $user = eZUser::fetch( $memberId );
    if ( $user != null && $user->isEnabled() )
    {
        $currentuser = eZUser::currentUser();
        $currentuser->logoutCurrent();
        $user->loginCurrent();
    }
    else
    {
        $memberId = false;
    }
}

if ( $memberId )
{
    /*
    // find out root url for main siteaccess of website
    $siteIni = eZINI::instance();
	$basesite = $siteIni->variable( 'SiteSetting', 'DefaultAccess' );
    $ini = eZINI::create( 'site.ini', 'settings', null, null, false );
    $ini->prependOverrideDir( "siteaccess/$basesite", false, 'siteaccess' );
    $ini->loadCache();
    $url = $ini->variable( 'SiteSetting', 'SiteURL' );
    */

    $url = $ini->variable( 'SiteSettings', 'SiteURL' );
/*
    if ( isset( $_GET['RedirectAfterLogin'] ) )
    {
        $url = $_GET['RedirectAfterLogin'];
    }
*/
    //print($url);
	//header( 'Location: ' . $url );
    return $module->redirectTo("/");
	eZExecution::cleanExit();
}
else
{
    // nb: alternative plus simple à tout ce qui suit:
    // return $Module->handleError( EZ_ERROR_KERNEL_ACCESS_DENIED, 'kernel' );

    $redirect = ezSys::serverVariable( "HTTP_REFERER" );
    if ( !$redirect )
    {
        $redirect = 'javascript: history.go(-1)';
    }
    $Result['pagelayout'] = 'pagelayout_empty.tpl';
    $tpl = templateInit();
    $tpl->setVariable( 'redirect_timeout', 5 );
    $tpl->setVariable( 'redirect_url', $redirect );
    $tpl->setVariable( 'redirect_message', "<h3>ERREUR</h3>Cet utilisateur n'est pas accessible. Retour en arriere dans 5 secondes...");
    $Result['content'] = $tpl->fetch( "design:simulate/redirectresponse.tpl" );
}

?>