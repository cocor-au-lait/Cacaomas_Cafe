private class GroupObject implements Cloneable {
    List<GameObject> objects;

    private GroupObject(GameObject ... objects) {
        this.objects = new ArrayList<GameObject>(Arrays.asList(objects));
    }

    @Override
    public GroupObject clone(){
        GroupObject group = new GroupObject();
        try {
            group = (GroupObject)super.clone();
            group.objects = new ArrayList<GameObject>();
            for(GameObject object : this.objects) {
                group.objects.add(object.clone());
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return group;
    }

    private List<GameObject> getObjects() {
        return objects;
    }

    private void jointGroup(GroupObject ... groups) {
        List<GameObject> temp = new ArrayList<GameObject>(this.objects);
        objects = new ArrayList<GameObject>();
        for(GroupObject group : groups) {
            this.addObjects(group.getObjects());
        }
        this.addObjects(temp);
    }

    private void addObjects(GameObject ... objects) {
        for(GameObject object : objects) {
            this.objects.add(object);
        }
    }

    private void addObjects(List<GameObject> objects) {
        for(GameObject object : objects) {
            this.objects.add(object);
        }
    }

    private void enableGroup() {
        for(GameObject object : objects) {
            object.enableObject();
        }
    }

    private void disableGroup() {
        for(GameObject object : objects) {
            object.disableObject();
        }
    }

    private void setBlend(int blend) {
        for(GameObject object : objects) {
            object.setBlend(blend);
        }
    }

    private void setColor(color colors) {
        for(GameObject object : objects) {
            object.setColor(colors);
        }
    }

    protected final void setColor(float colorB) {
        for(GameObject object : objects) {
            object.colorB = colorB;
            object.setColor(color(0.0f, 0.0f , colorB));
        }
    }

    protected final void setColor(float colorH, float colorS, float colorB) {
        for(GameObject object : objects) {
            object.colorH = colorH;
            object.colorS = colorS;
            object.colorB = colorB;
            object.setColor(color(colorH, colorS, colorB));
        }
    }

    private void setAlpha(float alpha) {
        for(GameObject object : objects) {
            object.setAlpha(alpha);
        }
    }

    private void addAlpha(float alpha) {
        for(GameObject object : objects) {
            object.addAlpha(alpha);
        }
    }

    private void addPosition(float posX, float posY) {
        for(GameObject object : objects) {
            object.addPosition(posX, posY);
        }
    }

    private void setRotation(float rotation) {
        for(GameObject object : objects) {
            object.setRotation(rotation);
        }
    }

    private void addRotation(float rotation) {
        for(GameObject object : objects) {
            object.addRotation(rotation);
        }
    }

    private void setScale(float scale) {
        for(GameObject object : objects) {
            object.setScale(scale);
        }
    }

    private void addScale(float scale) {
        for(GameObject object : objects) {
            object.addScale(scale);
        }
    }

    protected final void addState(String name, State state) {
        for(GameObject object : objects) {
            object.addState(name, state);
        }
    }

    protected final void startState(String ... names) {
        for(GameObject object : objects) {
            object.startState(names);
        }
    }

    protected final void stopState(String ... names) {
        for(GameObject object : objects) {
            object.stopState(names);
        }
    }
}
