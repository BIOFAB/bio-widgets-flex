
# Change this to point to your Flex SDK directory
FLEX_PATH=/opt/flex_sdk_3

all: plasmid-viewer sequence-viewer

as3corelib:
	git clone https://github.com/mikechambers/as3corelib
	rm -rf as3corelib/.git as3corelib/examples as3corelib/tests # not needed
	rm -rf as3corelib/src/com/adobe/air # must not be included when not compiling an air app
	cd as3corelib/build; FLEX_HOME=$(FLEX_PATH) ant; cd -

vectoreditor:
#	git clone https://code.google.com/p/vectoreditor/
	git clone https://github.com/JBEI/vectoreditor
	rm -rf vectoreditor/.git
	patch -p0 -i patches/plasmid_viewer.patch # patch for javascript integration
	patch -p0 -i patches/sequence_viewer.patch # patch for javascript integration

bioflex:
#	git clone https://code.google.com/p/bioflex/
	git clone https://github.com/JBEI/bioflex
	rm -rf bioflex/.git
	patch -p0 -i patches/bioflex.patch # patch needed to compile bioflex

plasmid-viewer: as3corelib bioflex vectoreditor
	$(FLEX_PATH)/bin/mxmlc -locale en_US -define=CONFIG::standalone,true -define=CONFIG::registryEdition,false -define=CONFIG::entryEdition,false -compiler.include-libraries=vectoreditor/VectorEditorStandalone/libs/PureMVC_AS3_2_0_4.swc -compiler.include-libraries=as3corelib/bin/as3corelib.swc -compiler.source-path=vectoreditor/VectorCommon/src -compiler.source-path=bioflex/bioflex/src -target-player=10.0.4 PlasmidViewerBiofab.mxml -output swf/plasmid_viewer.swf

sequence-viewer: as3corelib bioflex vectoreditor
	$(FLEX_PATH)/bin/mxmlc -locale en_US -define=CONFIG::standalone,true -define=CONFIG::registryEdition,false -define=CONFIG::entryEdition,false -compiler.include-libraries=vectoreditor/VectorEditorStandalone/libs/PureMVC_AS3_2_0_4.swc -compiler.include-libraries=as3corelib/bin/as3corelib.swc -compiler.source-path=vectoreditor/VectorCommon/src -compiler.source-path=bioflex/bioflex/src -target-player=10.0.4 SequenceViewerBiofab.mxml -output swf/sequence_viewer.swf

flex-3-install:
	echo "Installing the Flex 3 SDK."
	mkdir $(FLEX_PATH)
	echo "Downloading Flex 3."
	wget http://download.macromedia.com/pub/flex/sdk/flex_sdk_3.6a.zip -O $(FLEX_PATH)/flex_sdk.zip
	cd $(FLEX_PATH); unzip flex_sdk.zip; rm flex_sdk.zip; chmod -R go+rx $(FLEX_PATH)/*; cd -
	echo "Flex 3 has been installed."

flex-dataviz-install:
	echo "Installing the Flex 3 data visualization SDK"
	wget http://download.macromedia.com/pub/flex/sdk/datavisualization_sdk3.6.zip -O $(FLEX_PATH)/flex_dataviz.zip
	cd $(FLEX_PATH); unzip flex_dataviz.zip; rm flex_dataviz.zip; chmod -R go+rx $(FLEX_PATH)/*; cd -

