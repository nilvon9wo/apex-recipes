import { LightningElement, wire } from 'lwc';
import generateTreeData from '@salesforce/apex/RecipeTreeViewAuraCtrl.generateTreeData';

export default class RecipeTreeView extends LightningElement {
    @wire(generateTreeData)
    treeData;

    handleOnSelect(event) {
        event.preventDefault();
        const recipeSelectionEvent = new CustomEvent('select', {
            detail: event.detail.name
        });
        this.dispatchEvent(recipeSelectionEvent);
    }
}
