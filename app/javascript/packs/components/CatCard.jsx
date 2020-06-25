import EnergyImage from 'images/energy.jpg'
import LitterboxImage from 'images/litterbox.png';
import CatnipImage from 'images/catnip.png';
import ToyImage from 'images/cattoy.png';
import FoodImage from 'images/money.png';
import CoolCatImage from 'images/coolcat.png';
import ReactStringReplace from 'react-string-replace';
import React, {Fragment} from "react";
import ReactTooltip from "react-tooltip";

import MolassessImage from 'images/molasses.png';
import WillowImage from 'images/willow.jpg';
import PirateImage from 'images/pirate.jpg';
import RalphImage from 'images/ralphtest.png';
import LucyImage from 'images/lucy.jpg';
import SalemImage from 'images/salem.jpg';
import OliveImage from 'images/olive.png';


const imageMap = {
    'willow.jpg': WillowImage,
    'molasses.png': MolassessImage,
    'pirate.jpg':PirateImage,
    'ralphtest.png':RalphImage,
    'lucy.jpg':LucyImage,
    'salem.jpg':SalemImage,
    'olive.png': OliveImage
};
class CatCard extends React.Component {
    state = {};

    renderCustomImage = (name) => {
        return <img src={imageMap[name]} className="cat-img-js">

        </img>
    }

    renderRemoteImage = (name) => {
        return <img src={name} className="cat-img-js">

        </img>
    }

    renderCatLine = (line) => {
        let replacedText = line;
        replacedText = ReactStringReplace(replacedText, 'VP', (match, i) => (
            <img key={i} src={CoolCatImage} className="big-icon-js angry shorten"  />
        ));
        replacedText = ReactStringReplace(replacedText, ':trophy:', (match, i) => (
            <i key={i} className='fa fa-trophy'></i>
        ));
        replacedText = ReactStringReplace(replacedText, 'litterbox', (match, i) => (
            <img key={i} src={LitterboxImage} className="tolerance-js angry shorten u-4ml--xs u-4mr--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'catnip', (match, i) => (
            <img key={i} src={CatnipImage} className="tolerance-js angry shorten u-4ml--xs u-4mr--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'toy', (match, i) => (
            <img key={i} src={ToyImage} className="tolerance-js angry shorten u-4ml--xs u-4mr--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'food', (match, i) => (
            <img key={i} src={FoodImage} className="tolerance-js angry shorten u-4ml--xs u-4mr--xs"  />
        ));
        return replacedText;
    }

    renderImage = (card) => {
        if(card.self_hosted) {
            return this.renderCustomImage(card.tile_image);
        } else {
            return this.renderRemoteImage(card.tile_image);
        }
    }

    renderCatNeeds = (letters) => {
        let replacedText = letters;
        replacedText = ReactStringReplace(replacedText, 'F', (match, i) => (
            <img key={`${i}-food`} src={FoodImage} className="tolerance-js angry shorten u-4ml--xxs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'T', (match, i) => (
            <img key={`${i}-toy`} src={ToyImage} className="tolerance-js angry shorten u-4ml--xxs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'C', (match, i) => (
            <img key={`${i}-catnip`} src={CatnipImage} className="tolerance-js angry shorten u-4ml--xxs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'L', (match, i) => (
            <img key={`${i}-litterbox`} src={LitterboxImage} className="tolerance-js angry shorten u-4ml--xxs"  />
        ));
        return replacedText;
    }

    renderTopLineCat = (card) => {
        return <div className="full u-flex u-flex-space-between"><div>
                    <span>
                        { this.renderCatNeeds(card.number_tl)}
                    </span>
        </div>

            <div>
                {card.title}
            </div>

            <div>
                { this.renderCatNeeds(card.number_tr)}
            </div>
        </div>
    }

    renderTopLineAction = (card) => {
        return  <div className="full u-flex u-flex-space-between"><div>
                    <span>
                        { card.number_tl}
                    </span>
            <img className="u-4ml--xxs tolerance-js angry shorten" src={EnergyImage} />
        </div>

            <div>
                {card.title}
            </div>

            <div>
            </div>
        </div>

    }

    renderSubtype = (subtype, show_text) => {
        const text = show_text ? subtype : ''
        if(subtype == 'brat') {
            return <div className="bratty color-brat"><i className="fas fa-heart-broken"></i>️ {text} </div>
        } else if(subtype == 'curious') {
            return <div className="curious color-curious"><i className="fas fa-eye"></i>️ {text} </div>
        } else if(subtype == "cuddly") {
            return <div className="cuddly color-cuddly"><i className="fas fa-heart"></i>️ {text} </div>
        } else if(subtype == "furocious") {
            return <div className="furocious color-furocious"><i className="fas fa-fist-raised"></i>️ #{text} </div>
        } else if(subtype == "conspirator") {
            return <div className="conspirator color-conspirator"><i className="fas fa-cat"></i>️ #{text} </div>
        }
        return subtype;
    }

    renderCatHeader = (card) => {
        return <div className="cat-stats cat-stats-js row">
            <div className={`col-12 js-subtype color-${card.subtype}`}>
                { this.renderSubtype(card.subtype, true) }
            </div>
        </div>
    }


    render = () => {
        const {card, interact, selectedCardId } = this.props;
        return <React.Fragment>
            <ReactTooltip id={`${card.id}`} place="top" effect="solid">
                {card.hover_description || card.description}
            </ReactTooltip>
            <div key={card.id} className={`cat-card-js ${selectedCardId === card.id ? 'cat-card-js-highlighted' : ''}`} onClick={interact}  data-tip data-for={`${card.id}`}>
            { card.kind === 'cat' ? this.renderTopLineCat(card) : this.renderTopLineAction(card) }

            { this.renderImage(card) }
            { card.kind === 'cat' && this.renderCatHeader(card) }
            <div className="cat-mechanics">
                <h4 className="cat-description-js u-4mb--n">
                    { card.description.split("\n").map((row) => <div key={row}>{this.renderCatLine(row)}</div>) }
                </h4>

            </div>
        </div></React.Fragment>;
    }
}

export default CatCard;