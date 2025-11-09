class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  # before_action で @recipe = Recipe.find(params[:id]) を勝手に実行してくれる
  # これはコントローラーのメソッドを実行する前に必ず実行されるメソッド

  def index
    @recipes = Recipe.all
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: "レシピを登録しました"
    else
      flash.now[:alert] = "レシピを登録できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "レシピを更新しました"
      # redirect_to @recipe　→ Rails が @recipe から自動で URL を推測してくれる  (polymorphic routingのおかげ)
      # rails側は、redirect_to recipe_path(@recipe)　というふうに解釈している。
      
      # routes.rb の resources :recipesを見て、次のように判断している。
      # 1. Recipeモデル 2. そのshowページは/recipe/:id  3.@recipeならidが入っている。
      
      #redirect_to @recipe	/recipes/3 (例: id=3なら)
      #redirect_to recipes_path	/recipes
      #redirect_to edit_recipe_path(@recipe)	/recipes/3/edit
    else
      flash.now[:alert] = "レシピを更新できませんでした"
      # flash.now メッセージを表示してくれるやつ []の中身はラベルで、ここではalertというラベルを使っている。
      render :edit, status: :unprocessable_entity
      # render :edit ... URLを変えずに、edit.html.erbを表示し直す。 status: :unprocessable_entity は422エラーを返す。
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: "レシピを削除しました"
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
    # findメソッド : 指定したidが見つからない時、例外 (ActiveRecord::RecordNotFound) が発生する。　返り値はオブジェクト１つ
    # 必ず存在する前提で使用する。例）詳細ページ:showアクション   存在しない場合は404エラーが発生する。

    # find_byメソッド : 指定したidが見つからない時、nilを返す。　返り値はオブジェクト１つかnil
    # 存在しない場合はnilを返すので、条件分岐が必要。例）編集ページ:editアクション   存在しない場合は404エラーが発生しない。
    # 存在しない可能性のある検索で使用される。
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description, :ingredients, :instructions, :cook_time_minutes, :notes)
    # 「フォームから送られてきたデータを安全に受け取るための仕組み」 
    # フォームから送られてきたデータの中で、recipeの中にある、許可した項目だけを受け取るようにする。（それ以外は無視/ブロック)する。

    # これをやらないとWebフォームはユーザーが自由に改造できてしまうため、制御しなかった場合次のような危険な入力も通ってしまう。
    # 1.DBの勝手なカラムも更新できてしまう。
    # 2.管理者フラグをtrueに書き換えられてしまう。
    # 3.予期しないデータを送られて、DBが壊れてしまう。

  end
end
