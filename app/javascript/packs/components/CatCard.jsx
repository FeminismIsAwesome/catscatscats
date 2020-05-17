import EnergyImage from 'images/energy.jpg'
import WillowImage from 'images/willow.jpg';
import LitterboxImage from 'images/litterbox.png';
import CatnipImage from 'images/catnip.png';
import ToyImage from 'images/cattoy.png';
import FoodImage from 'images/money.png';
import CoolCatImage from 'images/coolcat.png';
import ReactStringReplace from 'react-string-replace';
import React, {Fragment} from "react";
const imageMap = {
    'willow': WillowImage
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
            <img key={i} src={CoolCatImage} className="big-icon angry shorten"  />
        ));
        replacedText = ReactStringReplace(replacedText, ':trophy:', (match, i) => (
            <i key={i} className='fa fa-trophy'></i>
        ));
        replacedText = ReactStringReplace(replacedText, 'litterbox', (match, i) => (
            <img key={i} src={LitterboxImage} className="tolerance angry shorten u-4ml--xs u-4mr--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'catnip', (match, i) => (
            <img key={i} src={CatnipImage} className="tolerance angry shorten u-4ml--xs u-4mr--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'toy', (match, i) => (
            <img key={i} src={ToyImage} className="tolerance angry shorten u-4ml--xs u-4mr--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'food', (match, i) => (
            <img key={i} src={FoodImage} className="tolerance angry shorten u-4ml--xs u-4mr--xs"  />
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
            <img key={i} src={FoodImage} className="tolerance angry shorten u-4ml--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'T', (match, i) => (
            <img key={i} src={ToyImage} className="tolerance angry shorten u-4ml--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'C', (match, i) => (
            <img key={i} src={CatnipImage} className="tolerance angry shorten u-4ml--xs"  />
        ));
        replacedText = ReactStringReplace(replacedText, 'L', (match, i) => (
            <img key={i} src={LitterboxImage} className="tolerance angry shorten u-4ml--xs"  />
        ));
        return replacedText;
    }

    renderTopLineCat = (card) => {
        return <div className="full u-flex u-flex-space-between"><div className="u-4ml--l">
                    <span className="u-4mr--s">
                        { this.renderCatNeeds(card.number_tl)}
                    </span>
        </div>

            <div>
                {card.title}
            </div>

            <div className="u-4mr--l">
                { this.renderCatNeeds(card.number_tr)}
            </div>
        </div>
    }

    iSwear = () => {
        fetch("/cats_games/2/act", {method: 'post'})
    }

    renderTopLineAction = (card) => {
        return  <div className="full u-flex u-flex-space-between"><div className="u-4ml--l">
                    <span className="u-4mr--s">
                        { card.number_tl}
                    </span>
            <img className="u-4ml--s tolerance angry shorten" src={EnergyImage} />
        </div>

            <div>
                {card.title}
            </div>

            <div className="u-4mr--l">
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
        return <div className="cat-stats row">
            <div className={`col-12 trophies color-${card.subtype}`}>
                { this.renderSubtype(card.subtype, true) }
            </div>
        </div>
    }


    render = () => {
        const {card} = this.props;
        return <div className="cat-card-js" onClick={this.iSwear}>
            { card.kind === 'cat' ? this.renderTopLineCat(card) : this.renderTopLineAction(card) }

            { this.renderImage(card) }
            { card.kind === 'cat' && this.renderCatHeader(card) }
            <div className="cat-mechanics">
                <h4 className="cat-description">
                    { card.description.split("\n").map((row) => <div key={row}>{this.renderCatLine(row)}</div>) }
                </h4>

            </div>
        </div>;
    }
}

export default CatCard;