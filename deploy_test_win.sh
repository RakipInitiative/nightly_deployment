#FOLDER="$TRAVIS_BUILD_DIR/de.bund.bfr.knime.update/target/repository"
KNIME_FILE="knime_3.7.2.win32.win32.x86_64.zip"

wget -q "http://download.knime.org/analytics-platform/win/$KNIME_FILE" 
unzip -q "$KNIME_FILE" 
echo $KNIME_FILE
rm $KNIME_FILE

KNIME37="https://update.knime.org/analytics-platform/3.7"
OLD_FSK="https://dl.bintray.com/silebat/test2"

NEW_FSK="https://dl.bintray.com/silebat/test2"



WF_ZIP="wf.zip"
wget -q https://dl.bintray.com/silebat/build_pipeline_test_wf/$WF_ZIP
unzip $WF_ZIP
rm $WF_ZIP
WF_FILES=wf/*
KNIME_SUCCESS="Workflow executed sucessfully"


echo "INSTALL NEW FSK-LAB INTO FRESH KNIME"
knime_3.7.2/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME37,$NEW_FSK" -installIU org.knime.features.testingapplication.feature.group
knime_3.7.2/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME37,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.r.x64.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group

for WF in $WF_FILES
  do
    KNIME_OUT=$(knime_3.7.2/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors)
    if [[ "$KNIME_OUT" != *"$KNIME_SUCCESS"* ]]; then  echo "$WF FAILED on 3.7.2";exit 1; else echo "$WF SUCCESS ON FRESH INSTALL 3.7.2"; fi
    rm outfile.table
  done  
 
echo "REMOVE NEW FSK TO TEST UPDATE FROM OLDER VERSION"
knime_3.7.2/knime -nosplash -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "================== TESTING THE UPDATE FROM OLD FSK-LAB ==============================================================================="
echo "INSTALL OLD FSK-LAB TEMPORARILY"
knime_3.7.2/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME37,$OLD_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REMOVING OLD FSK-LAB"
knime_3.7.2/knime -nosplash -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REINSTALLING NEW FSK-LAB"
knime_3.7.2/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME37,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group

for WF in $WF_FILES
  do
    KNIME_OUT=$(knime_3.7.2/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors)
    if [[ "$KNIME_OUT" != *"$KNIME_SUCCESS"* ]]; then  echo "$WF FAILED on 3.7.2";exit 1; else echo "$WF SUCCESS ON FRESH INSTALL 3.7.2"; fi
    rm outfile.table
  done 

echo "CLEANING KNIME"
rm -r knime_3.7.2 


# -------------------------------------------DO THE SAME FOR KNIME 4.1.3 -------------------------------------------------------------------

KNIME_FILE="knime_4.1.3.win32.win32.x86_64.zip"
wget -q "http://download.knime.org/analytics-platform/win/$KNIME_FILE" 
unzip -q "$KNIME_FILE" 
echo $KNIME_FILE
rm $KNIME_FILE

KNIME_FOLDER="knime_4.1.3"

KNIME41="https://update.knime.com/analytics-platform/4.1"

echo "================== TESTING THE FRESH INSTALL OF FSK-LAB of KNIME 4.1.3 ==============================================================="
echo "INSTALL NEW FSK-LAB INTO FRESH KNIME"
$KNIME_FOLDER/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME41,$NEW_FSK" -installIU org.knime.features.testing.application.feature.group
$KNIME_FOLDER/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME41,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group,de.bund.bfr.knime.r.x64.feature.feature.group

for WF in $WF_FILES
	do
		$KNIME_FOLDER/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors
  		OUTFILE=outfile.table
  		if test -f "$OUTFILE"; then echo "$WF SUCCESS ON FRESH $KNIME_FOLDER"; else echo "$WF FAILED ON $KNIME_FOLDER";exit 1; fi
  		rm outfile.table
	done

echo "REMOVE NEW FSK TO TEST UPDATE FROM OLDER VERSION"
$KNIME_FOLDER/knime -nosplash -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "================== TESTING THE UPDATE FROM OLD FSK-LAB ==============================================================================="

echo "INSTALL OLD FSK-LAB TEMPORARILY"
$KNIME_FOLDER/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME41,$OLD_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REMOVING OLD FSK-LAB"
$KNIME_FOLDER/knime -nosplash -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group
echo "REINSTALLING NEW FSK-LAB"
$KNIME_FOLDER/knime -nosplash -application org.eclipse.equinox.p2.director -repository "$KNIME41,$NEW_FSK" -installIU de.bund.bfr.knime.fsklab.feature.feature.group,de.bund.bfr.knime.foodprocess.feature.feature.group,de.bund.bfr.knime.pmm.feature.feature.group


for WF in $WF_FILES
	do
		$KNIME_FOLDER/knime -nosplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="$WF" --launcher.suppressErrors 
		OUTFILE=outfile.table
  		if test -f "$OUTFILE"; then echo "$WF SUCCESS ON FRESH $KNIME_FOLDER"; else echo "$WF FAILED ON $KNIME_FOLDER";exit 1; fi
  		rm outfile.table
	done

echo "CLEANING KNIME"
rm -r $KNIME_FOLDER 
rm -r wf 
