class BoxObject extends GameObject {
    PVector size = new PVector();
    color strokeColor;
    float strokeBold;
    float objectAlpha = 1F;
    float strokeAlpha;

    @Override
    BoxObject clone() {
        BoxObject boxObject = new BoxObject();
        try {
            boxObject = (BoxObject) super.clone();
            boxObject.position = this.position.copy();
            boxObject.diagonalPosition = this.diagonalPosition.copy();
            boxObject.size = this.size.copy();
            boxObject.anchor = this.anchor.copy();
            boxObject.rotation = this.rotation.copy();
            boxObject.align = this.align.copy();
            /*object.states = new HashMap<String, State>(this.states);
            for(Entry<String, State> entry : object.states.entrySet()) {
                object.addState(entry.getKey(), entry.getValue());
            }*/
        } catch(Exception e) {
            e.printStackTrace();
        }
        return boxObject;
    }

    @Override
    void onUpdate() {
        switch(align.x) {}
        switch(align.y) {}
        switch(align.z) {}
    }

    @Override
    void moveObject(PVector scaledSize) {
        PVector anchorPosition = new PVector();
        scaledAnchor.x = anchor.x * scaledSize.x + widthMargin;
        scaledAnchor.y = anchor.y * scaledSize.y + heightMargin;
        scaledAnchor.z = anchor.z * scaledSize.z;
        translate(scaledAnchor.x, scaledAnchor.y, scaledAnchor.z);
        PVector realPosition = new PVector();
        scaledPosition.x = position.x * scaledSize.x + widthMargin;
        scaledPosition.y = position.y * scaledSize.y + heightMargin;
        scaledPosition.z = position.z * scaledSize.z;
        translate(scaledPosition.x, scaledPosition.y, scaledPosition.z);
    }

    @Override
    void drawObject(PVector scaledSize) {
        fill(objectColor, alpha);
        strokeWeight(strokeBold * displayScale);
        stroke(strokeColor, strokeAlpha);
        box(scaledSize.x, scaledSize.y scaledSize.z);
    }
}
