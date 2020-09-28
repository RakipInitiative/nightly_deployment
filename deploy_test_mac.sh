# Test on non-empty KNIME

KNIME="/Applications/KNIME\ 4.2.1.app/Contents/MacOS/knime"
KNIME_UPDATE_SITE="https://update.knime.com/analytics-platform/4.0"
FSK_UPDATE_SITE="https://dl.bintray.com/silebat/development"
# Dependencies are previously installed
DEPENDENCIES="org.knime.features.testing.application.feature.group"
FEATURES="de.bund.bfr.knime.fsklab.feature.feature.group"

echo "1. Install FSK-Lab into KNIME from development update site"
bash -c "$KNIME -noSplash -application org.eclipse.equinox.p2.director -repository $KNIME_UPDATE_SITE,$FSK_UPDATE_SITE -installIU $FEATURES"

echo "2. Download test workflows"
wget -q https://dl.bintray.com/silebat/build_pipeline_test_wf/wf.zip
unzip wf.zip -d wf

echo "3. Run test workflows"
for WF in wf/*
	do
		bash -c "$KNIME -noSplash -reset -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile=$WF --launcher.suppressErrors"
		OUTFILE=outfile.table
  		if test -f "$OUTFILE"; then echo "$WF SUCCESS ON UPDATE $KNIME"; else echo "$WF FAILED ON UPDATE $KNIME";exit 1; fi
  		rm outfile.table
	done

echo "3. Remove FSK-Lab from KNIME"
bash -c "$KNIME -application org.eclipse.equinox.p2.director -uninstallIU de.bund.bfr.knime.fsklab.feature.feature.group"

echo "4. Remove workflows"
rm -Rf wf
rm wf.zip