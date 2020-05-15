KNIME_FILE="knime_3.7.2.linux.gtk.x86_64.tar.gz"
wget -q "http://download.knime.org/analytics-platform/linux/$KNIME_FILE"
tar -xzf $KNIME_FILE
rm $KNIME_FILE

KNIME37="https://update.knime.org/analytics-platform/3.7"
OLD_FSK="https://dl.bintray.com/silebat/test2"
NEW_FSK="https://dl.bintray.com/silebat/test2"

WF_REP="https://dl.bintray.com/silebat/build_pipeline_test_wf"
WF_ZIP_FOLDER="wf.zip"
wget -q $WF_REP/$WF_ZIP_FOLDER

unzip $WF_ZIP_FOLDER -d wf
rm $WF_ZIP_FOLDER

WF_FILES=wf/*
KNIME_SUCCESS="Workflow executed sucessfully"


echo "================== TESTING THE FRESH INSTALL OF FSK-LAB of KNIME 3.7.2 ==============================================================="

echo "INSTALL NEW FSK-LAB INTO FRESH KNIME"
knime_3.7.2/knime -application org.eclipse.equinox.p2.director -repository "$KNIME37,$NEW_FSK" -installIU org.knime.features.testingapplication.feature.group
knime_3.7.2/knime -application org.eclipse.equinox.p2.director -repository "$KNIME37,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group

for WF in $WF_FILES
	do
		KNIME_OUT=$(knime_3.7.2/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors)
  		if [[ "$KNIME_OUT" != *"$KNIME_SUCCESS"* ]]; then  echo "$WF FAILED ON FRESH 3.7.2";exit 1; else echo "3.7.2 WORKFLOW $WF SUCCESSFUL ON FRESH INSTALL"; fi
  		rm outfile.table
	done

echo "REMOVE NEW FSK TO TEST UPDATE FROM OLDER VERSION"
knime_3.7.2/knime -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "================== TESTING THE UPDATE FROM OLD FSK-LAB ==============================================================================="
echo "INSTALL OLD FSK-LAB TEMPORARILY"
knime_3.7.2/knime -application org.eclipse.equinox.p2.director -repository "$KNIME37,$OLD_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REMOVING OLD FSK-LAB"
knime_3.7.2/knime -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REINSTALLING NEW FSK-LAB"
knime_3.7.2/knime -application org.eclipse.equinox.p2.director -repository "$KNIME37,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group

for WF in $WF_FILES
	do
		KNIME_OUT=$(knime_3.7.2/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors)
		if [[ "$KNIME_OUT" != *"$KNIME_SUCCESS"* ]]; then  echo "$WF FAILED ON UPDATE 3.7.2";exit 1; else echo "3.7.2 WORKFLOW $WF SUCCESSFUL ON UPDATE"; fi
  		rm outfile.table
	done

echo "CLEANING KNIME"
rm -Rf knime_3.7.2

# -------------------------------------------DO THE SAME FOR KNIME 4.1.2 -------------------------------------------------------------------

KNIME_FILE="knime_4.1.3.linux.gtk.x86_64.tar.gz"
wget -q "http://download.knime.org/analytics-platform/linux/$KNIME_FILE"
tar -xzf $KNIME_FILE
rm $KNIME_FILE

KNIME_FOLDER="knime_4.1.3"

KNIME41="https://update.knime.com/analytics-platform/4.1"

echo "================== TESTING THE FRESH INSTALL OF FSK-LAB of KNIME 4.1.2 ==============================================================="
echo "INSTALL NEW FSK-LAB INTO FRESH KNIME"
$KNIME_FOLDER/knime -application org.eclipse.equinox.p2.director -repository "$KNIME41" -installIU org.knime.features.testing.application.feature.group
$KNIME_FOLDER/knime -application org.eclipse.equinox.p2.director -repository "$KNIME41,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group

for WF in $WF_FILES
	do
		$KNIME_FOLDER/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors
  		OUTFILE=outfile.table
  		if test -f "$OUTFILE"; then echo "$WF SUCCESS ON FRESH $KNIME_FOLDER"; else echo "$WF FAILED ON FRESH $KNIME_FOLDER";exit 1; fi
  		rm outfile.table
	done

echo "REMOVE NEW FSK TO TEST UPDATE FROM OLDER VERSION"
$KNIME_FOLDER/knime -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "================== TESTING THE UPDATE FROM OLD FSK-LAB ==============================================================================="

echo "INSTALL OLD FSK-LAB TEMPORARILY"
$KNIME_FOLDER/knime -application org.eclipse.equinox.p2.director -repository "$KNIME41,$OLD_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REMOVING OLD FSK-LAB"
$KNIME_FOLDER/knime -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REINSTALLING NEW FSK-LAB"
$KNIME_FOLDER/knime -application org.eclipse.equinox.p2.director -repository "$KNIME41,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group


for WF in $WF_FILES
	do
		$KNIME_FOLDER/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors 
		OUTFILE=outfile.table
  		if test -f "$OUTFILE"; then echo "$WF SUCCESS ON UPDATE $KNIME_FOLDER"; else echo "$WF FAILED ON UPDATE $KNIME_FOLDER";exit 1; fi
  		rm outfile.table
	done

echo "CLEANING KNIME"
rm -Rf $KNIME_FOLDER
rm -Rf wf